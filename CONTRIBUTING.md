# Contributing to blockinfile role/module

If you're going to contribute and make a pull request in the GitHub project,
please consider including some tests for features/fixes
you want to add in the PR.

# Module testing infrastructure

Run `bash run.sh` in tests dir.
It copies fixtures dir to testing (working) dir,
then for each of tests (tests/*.yml) it runs ansible-playbook twice
(the second run is for idempotency check)
and see difference between files in testing dir and ones in expected dir.

You can add your own tests by adding the following files and dirs:
- tests/test-the-feature.yml - A playbook to test "the feature."
- tests/fixtures/test-the-feature/... - Put fixtures to be tested.
- tests/expected/test-the-feature/... - Put expected results after running playbook.

