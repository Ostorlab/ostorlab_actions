# Ostorlab Github Action

![Ostorlab ci_can for GithubAction](https://i.ibb.co/XF3cwWw/image.png)

Ostorlab scans mobile applications (Android APK, AAB, iOS IPA) and web applications for security and privacy issues. It provides full
coverage by detecting issues on both the client-side and service-side, covering both the application code and
all of its dependencies.

Ostorlab supports all major frameworks, both native and multi-platform. This includes Java, Kotlin, Objective C,
Swift, Flutter, Cordova, React Native, Ionic and Xamarin.

Ostorlab provides both static and dynamic analysis capabilities, detecting over 500 vulnerability classes, like
hardcoded secrets, privacy data leakage, untrusted input inject, outdated dependencies with a database of over 120k
known vulnerable dependency.

## Getting Started

To use Ostorlab Github Action, the first step is to generate an API key. To do so, simply follow the following steps:

1. Go to the [API keys menu](https://report.ostorlab.co/library/api/)
2. Click the new button to generate a new key
3. Copy the api key (You can add a name and an expiry date to your key)
4. Click the save button to save your key
   (You can add a name and an expiry date to your key), do not forget to click the save button to save your key.

![api key](https://github.com/jenkinsci/ostorlab-plugin/raw/master/images/jenkins-apikey.png)

Once you have generated your API, add it to GitHub Secrets. Make sure the name matches the secrets.<n> in the YAML
file. You follow these steps for more detailed
instructions [Github:Creating encrypted secrets for a repository](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

The next steps is to a update your workflow to add an Ostorlab step to trigger the scan. Below is a sample performing
a rapid scan on an Android APK and failing the pipeline on vulnerabilities with `HIGH` severity.

```yaml
on: [push]
jobs:
  ostorlab_test:
    runs-on: ubuntu-latest
    name: Test ostorlab ci actions.
    steps:
      - uses: actions/checkout@v2
      - name: build ostorlab.apk
        run: mv InsecureBankv2.apk ostorlab.apk
      - name: Launch Ostorlab scan
        id: start_scan
        uses: Ostorlab/ostorlab_actions@v1.1.1
        with:
          scan_profile: fast_scan # Specify which scan profile to use for the scan (check scan section).
          asset_type: android-apk # type of asset to scan.
          target: ostorlab.apk # path for target tto scan.
          scan_title: title_scan_ci # type a title for your scan.
          ostorlab_api_key: ${{ secrets.ostorlab_api_key }} # your secret api key.
          break_on_risk_rating: HIGH # Wait for the scan results and force the action to fail if the scan risk is higher
          max_wait_minutes: 30
      - name: Get scan id
        run: echo "Scan Created with id ${{ steps.start_scan.outputs.scan_id }} you can access the full report at https://report.ostorlab.co/scan/${{ steps.start_scan.outputs.scan_id }}/"

```

### Scanning Web Applications

Ostorlab also supports scanning web applications. You can specify a single web application or multiple web applications to scan. Below is an example of scanning multiple web applications:

```yaml
on: [push]
jobs:
  ostorlab_web_scan:
    runs-on: ubuntu-latest
    name: Test ostorlab web scan.
    steps:
      - uses: actions/checkout@v2
      - name: Launch Ostorlab web scan
        id: start_scan
        uses: Ostorlab/ostorlab_actions@v1.1.1
        with:
          scan_profile: full_web_scan
          asset_type: link
          target: --url https://target1.co --url https://target2.ostorlab.co --url https://target3.ostorlab.co --url https://target4.ostorlab.co
          scan_title: web_scan_ci
          ostorlab_api_key: ${{ secrets.ostorlab_api_key }}
          break_on_risk_rating: HIGH
          max_wait_minutes: 60
      - name: Get scan id
        run: echo "Scan Created with id ${{ steps.start_scan.outputs.scan_id }} you can access the full report at https://report.ostorlab.co/scan/${{ steps.start_scan.outputs.scan_id }}/"
```

When scanning web applications, make sure to:
- Use `scan_profile: full_web_scan` for comprehensive web scanning
- Set `asset_type: link` to indicate you're scanning web applications
- In the `target` field, list all URLs you want to scan using the `--url` flag before each URL
- For example: `target: --url https://target1.co --url https://target2.ostorlab.co --url https://target3.ostorlab.co --url https://target4.ostorlab.co`

This configuration allows you to scan multiple web applications in a single job, making it efficient to test related web services together.

### Sbom/Lock Files

You can supply your SBOM/Lock files to enhance the scan analysis, to do so use the `extra` 
input to pass `--sbom***`, for example to add package-lock.json file use the following example:

```yaml
extra:  --sbom package-lock.json
```
Here you can see the list of the supported files:

- buildscript-gradle.lockfile
- Cargo.lock,
- composer.lock,
- conan.lock,
- Gemfile.lock,
- go.mod,
- gradle.lockfile,
- mix.lock,
- Pipfile.lock,
- package-lock.json,
- packages.lock.json,
- pnpm-lock.yaml,
- poetry.lock,
- pom.xml,
- pubspec.lock,
- requirements.txt,
- yarn.lock,


### Test Credentials

Ostorlab supports performing authenticated testing with either simple login password or custom inputs identified with
name/label and passing value.

To pass test credentials, since the Github YAML Action do not support passing complex objects, you can use the `extra`
input to pass `--test-credetials-***`. For instance to add login/password and a custom credentials with custom names
and values, add the following input:

```yaml
extra: --test-credentials-login test_login --test-credentials-password test_pass --test-credentials-role ci_role --test-credentials-name foo1 --test-credentials-value bar1 --test-credentials-name foo2 --test-credentials-value bar2
```

### Action inputs

The Github actions the following options:

- **`scan_profile`** *(['fast_scan', 'full_scan', 'full_web_scan'])*: [Required] - Specifies the scan profile ( `fast_scan` for fast
  static only analysis, `full_scan` for full static, dynamic and backend coverage, and `full_web_scan` for web application scanning).
- **`asset_type`** *(['android-apk', 'android-aab', 'ios-ipa', 'link'])*: [Required] - Target asset, Ostorlab supports APK, AAB,
  IPA, and web applications (link). For web applications, use `link`.
- **`target`**: [Required] - For mobile applications: path to the file to scan. For web applications: list of URLs to scan using the format `--url https://example1.com --url https://example2.com`.
- **`ostorlab_api_key`**: [Required] - API Key from Ostorlab portal.
- **`scan_title`**: [Optional] - A scan title to identify your scan.
- **`break_on_risk_rating`** *(['HIGH', 'MEDIUM', 'LOW','POTENTIALLY])*: [Optional] - Wait for the scan results and
  force the action to fail if the risk rating match or is higher than the provided value.
- **`max_wait_minutes`**: [Optional] - Max wait time in minutes, pipeline will not fail if the scan times out.
- **`extra`**: [Optional] - Extra argument flags to pass to the Ostorlab ci-scan CLI. Common use case is passing the scan
  test credentials.

### Action outputs

- **`scan_id`** - The scan id is accessible using the following syntax ${{ steps.STEP_ID.outputs.scan_id }}.

### More details

- [ostorlab.co](https://www.ostorlab.co/)
- [Risk Ratings](https://docs.ostorlab.co/guide/#risk-ratings)
- [Ostorlab SDK](https://github.com/ostorlab/ostorlab)
