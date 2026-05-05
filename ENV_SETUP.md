# Environment Variables Setup Guide

## Overview
This project uses environment variables to manage sensitive API keys and secrets. These are loaded from a `.env` file using the `flutter_dotenv` package.

## Setup Instructions

### 1. Create a `.env` file
Copy the `.env.example` file to create a new `.env` file in the project root:

```bash
cp .env.example .env
```

### 2. Add your API keys
Edit the newly created `.env` file and add your actual API keys:

```
CHAT_GPT_API_KEY=sk-proj-your-actual-key-here
STRIPE_PUBLISHABLE_KEY=pk_test_your-actual-key-here
```

### 3. Important Security Notes

- **Never commit the `.env` file** - It's already added to `.gitignore` to prevent accidental commits
- **Keep `.env.example` in the repository** - This serves as a template for other developers
- **For production builds**, create a separate `.env.production` file or use CI/CD environment variables
- **For different environments**, you can create `.env.development` and `.env.production` files

### 4. How it Works

- The `flutter_dotenv` package loads the `.env` file when the app starts
- API keys are accessed through the `AppStrings` class:
  ```dart
  String chatGptKey = AppStrings.chatGpt;
  String stripeKey = AppStrings.stripe;
  ```

### 5. For CI/CD or Deployment

If you're deploying via CI/CD (GitHub Actions, etc.):

1. **In GitHub Secrets**, add your API keys as repository secrets
2. **In your workflow file**, create the `.env` file during the build:
   ```yaml
   - name: Create .env file
     run: |
       echo "CHAT_GPT_API_KEY=${{ secrets.CHAT_GPT_API_KEY }}" > .env
       echo "STRIPE_PUBLISHABLE_KEY=${{ secrets.STRIPE_PUBLISHABLE_KEY }}" >> .env
   ```

## Troubleshooting

If you see errors about missing API keys:
1. Ensure `.env` file exists in the project root
2. Verify the key names match exactly (case-sensitive): `CHAT_GPT_API_KEY`, `STRIPE_PUBLISHABLE_KEY`
3. Run `flutter pub get` after modifying `pubspec.yaml`
4. Restart the development server

## References

- [flutter_dotenv Documentation](https://pub.dev/packages/flutter_dotenv)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

