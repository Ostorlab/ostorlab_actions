# Ostorlab Github Action

![Ostorlab ci_can for GithubAction](https://i.ibb.co/XF3cwWw/image.png)

Ostorlab scans mobile applications (Android APK, AAB, iOS IPA) for security and privacy issues. It provides full
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

Once you have generated your API, add it to GitHub Secrets. Make sure the name matches the secrets.<name> in the YAML
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

### UI Prompts

UI Prompts are a powerful feature that allows you to use natural language to guide the scanner on how to navigate and interact with your mobile application during dynamic analysis. This enables the scanner to perform more comprehensive testing by following specific user flows and testing authenticated features.

#### What are UI Prompts?

UI Prompts are natural language instructions that tell the Ostorlab scanner how to interact with your application's user interface. They can include:
- Login instructions with specific credentials
- Navigation steps to reach certain features
- Actions to perform (like making transactions, filling forms, etc.)
- Sequential workflows that simulate real user behavior

#### How to Use UI Prompts

To add UI prompts to your scan, use the `extra` input with the `--ui-prompt` flag. You can specify multiple UI prompts by repeating the `--ui-prompt` flag for each instruction:

```yaml
extra: --ui-prompt="First instruction here" --ui-prompt="Second instruction here"
```

#### Examples

**Basic Login Flow:**
```yaml
extra: --ui-prompt="Login with username 'test_user' and password 'test_pass'"
```

**Complex User Flow:**
```yaml
extra: --ui-prompt="Ensure to login with username test_login and password test_pass" --ui-prompt="Navigate to the Transfer Funds section and make a transfer of 100 to account number 123456"
```

**Combined with Test Credentials:**
```yaml
extra: --test-credentials-login test_login --test-credentials-password test_pass --test-credentials-role ci_role --ui-prompt="Login using the provided test credentials" --ui-prompt="Navigate to the settings page and update user profile"
```

**Multi-step E-commerce Flow:**
```yaml
extra: --ui-prompt="Login with the test account credentials" --ui-prompt="Add a product to the shopping cart" --ui-prompt="Proceed to checkout and complete the purchase flow"
```
#### UI Prompt Use Cases

- **Authentication Testing**: Guide the scanner through login processes
- **Feature Coverage**: Ensure the scanner tests specific app features
- **User Journey Testing**: Simulate complete user workflows
- **Permission Testing**: Navigate through permission-sensitive areas
- **Transaction Testing**: Test financial or sensitive operations
- **Form Validation**: Test form inputs and validation logic

### Action inputs

The Github actions the following options:

- **`scan_profile`** *(['fast_scan', 'full_scan'])*: [Required] - Specifies the scan profile ( `fast_scan` for fast
  static only analysis and `full_scan` for full static, dynamic and backend coverage).
- **`asset_type`** *(['android-apk', 'android-aab', 'ios-ipa'])*: [Required] - Target asset, Ostorlab supports APK, AAB
  and IPA.
- **`target`**: [Required] - target file to scan.
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
