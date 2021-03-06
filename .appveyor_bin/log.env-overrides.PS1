# highlight any non-default (ie, non-null) environment vars (from the set of configuration vars)
# ref: http://www.powertheshell.com/input_psv3 @@ https://archive.is/D7z8m
# ref: https://kevinmarquette.github.io/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about @@ https://archive.is/Ln6cg
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

@($Input) | & {

  $data_a = @($Input)
  #write-host "count = $($data_a.count)"
  if ( $data_a.count -eq 0 ) { $data_a = @(get-childitem env:) }
  $data = @{}
  $data_a |% { $data[$_.key]=$_.value }

  $CI_vars = @(
    # configuration environment variables expected to be null
    'AUTHOR_TESTING', 'RELEASE_TESTING',
    'TEST_ALL', 'TEST_AUTHOR', 'TEST_RELEASE',
    # 'AUTOMATED_TESTING',
    'COVERAGE',
    # 'CI_CACHE_DIR',
    'CI_DEBUG', 'CI_DEBUG_PERL_INSTALL',
    # 'CI_HELPER_API_VERSION',
    'CI_HELPER_BRANCH',
    'CI_HELPER_BRANCH_DESC',
    'CI_HELPER_REPO', 'CI_HELPERS',
    'CI_TEMP_DIR',
    'CI_SKIP', 'CI_SKIP_TEST',
    'DEVEL_COVER_OPTIONS',
    'DIST_EXTRA_DEPS','DIST_SUPPRESS_DEPS', 'DIST_SUPPRESS_RECS',
    'DIST_TOOLING',
    'HARNESS_OPTIONS','HARNESS_PERL_SWITCHES', 'HARNESS_TIMER'
    # 'make',
    'OS_unsupported',
    'PERL5OPT',
    'TEST_FILES', 'TEST_METHOD',
    $null
    );

  $overrides = @();

  #$CI_vars |% { $v = (get-item env:$_ -ea silent).value; if ($null -ne $v) { $overrides += "$_=$v" }}
  #$CI_vars |% { $v = $data[$_]; if (($null -ne $_) -and ($null -ne $v)) { $overrides += "$_=$v" }}
  $CI_vars |% { if ($null -ne $_) { $v = $data[$_]; if ($null -ne $v) { $overrides += "$_=$v" } } }

  if ( $overrides ) { write-host -fore yellow $($(@("") + $overrides + @("")) -join "`r`n") }

}

set-PSdebug -off
exit $exit_val
