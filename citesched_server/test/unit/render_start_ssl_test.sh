#!/bin/sh

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
START_SCRIPT="$(CDPATH= cd -- "$SCRIPT_DIR/../../deploy/render" && pwd)/start.sh"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

cat > "$TEST_DIR/production.yaml" <<'EOF'
database:
  host: fallback.example
  port: 5432
  name: citesched
  user: test-user
  requireSsl: true
EOF

SERVERPOD_PRODUCTION_CONFIG_FILE="$TEST_DIR/production.yaml"
. "$START_SCRIPT"

assert_ssl() {
  expected="$1"
  description="$2"
  if ! load_database_config; then
    echo "FAIL: $description (configuration was rejected)" >&2
    exit 1
  fi
  if [ "$DB_REQUIRE_SSL" != "$expected" ]; then
    echo "FAIL: $description (expected $expected, got $DB_REQUIRE_SSL)" >&2
    exit 1
  fi
  echo "PASS: $description"
}

reset_config() {
  unset SERVERPOD_DATABASE_URL SERVERPOD_DATABASE_REQUIRE_SSL
  unset DATABASE_URL RENDER_DATABASE_URL
  unset SERVERPOD_DATABASE_HOST SERVERPOD_DATABASE_PORT
  unset SERVERPOD_DATABASE_NAME SERVERPOD_DATABASE_USER
  unset SERVERPOD_DATABASE_PASSWORD
  DB_HOST=""
  DB_PORT=""
  DB_NAME=""
  DB_USER=""
  DB_PASSWORD=""
  DB_REQUIRE_SSL=""
}

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb?application_name=test&sslmode=require'
assert_ssl true "URL sslmode=require enables SSL"
write_production_config
if ! grep -Fxq '  requireSsl: true' "$TEST_DIR/production.yaml"; then
  echo "FAIL: URL SSL mode was not written to Serverpod production config" >&2
  exit 1
fi
echo "PASS: URL SSL mode is written to Serverpod production config"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb?sslmode=verify-full'
assert_ssl true "URL sslmode=verify-full enables SSL"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb?sslmode=disable'
assert_ssl false "URL sslmode=disable disables SSL"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb?sslmode=ALLOW'
assert_ssl true "URL sslmode=allow uses SSL when supported"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb?sslmode=require'
SERVERPOD_DATABASE_REQUIRE_SSL=false
assert_ssl false "explicit false override takes precedence over URL"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb'
SERVERPOD_DATABASE_REQUIRE_SSL=true
assert_ssl true "explicit true override enables SSL"

reset_config
SERVERPOD_DATABASE_REQUIRE_SSL=false
assert_ssl false "explicit false override works without a database URL"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb'
assert_ssl true "URL without sslmode uses production config"

cat > "$TEST_DIR/production.yaml" <<'EOF'
database:
  host: fallback.example
  port: 5432
  name: citesched
  user: test-user
  requireSsl: false
EOF
reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@server.render.com/defaultdb'
assert_ssl false "URL without sslmode does not infer SSL from Render hostname"

reset_config
SERVERPOD_DATABASE_URL='postgres://test-user:test-password@db.example:25984/defaultdb'
SERVERPOD_DATABASE_REQUIRE_SSL=not-a-boolean
if load_database_config >"$TEST_DIR/stdout" 2>"$TEST_DIR/stderr"; then
  echo "FAIL: invalid override should be rejected" >&2
  exit 1
fi
if grep -E 'test-password|postgres://' "$TEST_DIR/stdout" "$TEST_DIR/stderr" >/dev/null; then
  echo "FAIL: database credentials were printed" >&2
  exit 1
fi
echo "PASS: invalid override is rejected without logging database credentials"
