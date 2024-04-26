# Alternative DPI Mentorship Platform

Discovery Partners Institute's full stack software development apprenticeship program has a mentoring component where the trainees are matched to working professionals to help with their transition into tech. This is an alternative platform that looks to solve some of the frustrations and issues occurring with the current mentorship platform, including but not limited to: 
- No data retained from past cohorts unless using the paid tier
- Request-based matching which introduces needless competition amongst trainees for mentors and creates period of uncertainity while trainees wait for a response
- Mentor profiles are only visible during the request matching period

## Key Features
This mentorship platform allows users to:
- Create and maintain multiple mentorship programs
- Join programs as a mentee or mentor and see the profiles of users in the program with the counterpart role
- As a mentee, rank the mentors in order of their preference to match
- As a program admin, edit and delete the members of the program and update relevant details like role
- As a program admin, view mentor availabilities and mentee preferences and pair mentees to mentors accordingly

## Limitations and Future Features
The platform currently still has limitations to be addressed in future features:
- All matching is done manually by the admin, who has to parse through open mentor availability and mentee rankings
- Users need to find the program they want to join from an index of programs, some which may not be relevant to the user
- Anyone can sign up to use the application and join any program they want

## Getting Started
### Dependencies
This application uses PostgreSQL database, which can be installed and ran locally using the steps listed [here](https://www.prisma.io/dataguide/postgresql/setting-up-a-local-postgresql-database).

This application also relies on [Devise](https://github.com/heartcombo/devise) for user authentication and [Pundit](https://github.com/varvet/pundit) for authorization. 

This application utilizes AWS S3 buckets to store images for user profile pictures and program banner images. In order to use your S3 buckets for your application, complete the following steps **after** following the installation steps:
- Sign up for an AWS account and set up an S3 bucket
- Configure an IAM user for your bucket with the appropriate policy attached.
- Create an access key and secret access key for the configured IAM user so the application can access the bucket
- In the terminal, run the following code: 
```
EDITOR="code --wait" rails credentials:edit
```
- Add your generated AWS credentials, as well as bucket name and region, to the opened credentials.yml: 
```
aws:
  access_key_id: YOUR_ACCESS_KEY_ID
  secret_access_key: YOUR_SECRET_ACCESS_KEY
  region: YOUR_BUCKET_REGION
  bucket: YOUR_BUCKET_NAME
```
- Add the key to your credentials.yml (usually named master.key) to your .gitignore file to prevent it from being accidentally pushed to your repository.

### Installing
1. Clone the main branch of this repository into your local development environment: git clone https://github.com/jeeheezy/DPI-mentorship-platform.git
2. Create a database: rake db:create
3. Run the database migrations: rake db:migrate
4. (Optional) Add sample data: rake sample_data. The script sets up a series of test users, including alice@example.com who's generally an admin user and bob@example.com for mentor/mentee user. Both users have the password password.
- If you'd like to run steps 2-4 together, optionally can also run rails dev:reset

### Executing Program
You can start the development server by running bin/dev.

## Contribution Guidelines
### How to Contribute
1. **Setup your environment**: Follow the installation instructions above.
2. **Find an issue to work on**: Choose an issue that's listed the issues tab of the repository.

### Coding Conventions
We adhere to the Ruby community style guide, and we expect all contributors to follow suit. Here are key conventions specific to our project:

- **Code Style**: Follow the [Ruby Style Guide](https://rubystyle.guide/), which provides detailed guidelines on the coding style preferred by the Ruby community.
- **Naming Conventions**:
  - Use `snake_case` for variables, methods, and file names.
  - Use `PascalCase` for class and module names.
  - Reflect domain concepts accurately in naming. For instance, if you are working within a medical application, prefer names like `patient_record` over vague terms like `data_entry`.

- **Design Principles**: Focus on Domain-Driven Design (DDD):
  - Organize code to reflect the domain model clearly.
  - Use service objects, decorators, and other design patterns that help isolate domain logic from application logic.

- **Testing Conventions**:
  - Write tests for all new features and bug fixes.
  - Use RSpec for testing, adhering to the [RSpec Style Guide](https://rspec.rubystyle.guide/).
  - Ensure test names clearly describe their purpose, reflecting domain-specific terminology.

### Comments and Documentation
- **Comment your code** where necessary to explain "why" something is done, not "what" is done—source code should be self-explanatory regarding the "what".
- **Document methods and classes** thoroughly, focusing on their roles within the domain model, especially for public APIs.

### Version Control Practices
- Commit messages should be clear and follow best practices, such as those outlined in [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/).
- Keep commits focused on a single issue to simplify future maintenance and troubleshooting.

### Branch Naming Conventions
Please use the following naming conventions for your branches:

- `<issue#-description>` (e.g. 31-added-ransack-search)

### Pull Request Process
1. **Creating a Pull Request**: Provide a detailed PR description, referencing the issue it addresses.
2. **Review Process**: PRs require review from at least one maintainer.

### Acknowledgment of Contributors
Contributors who make significant contributions will be listed in our [README/CONTRIBUTORS] file.

Thank you for contributing to our mentorship platform!


## FAQ

### AWS Errors
Be sure to follow the steps for configuring the credentials.yml to include your AWS access keys. You may need to delete a pre-existing credentials.yml file before doing the steps listed above to ensure your master key opens your credentials.yml properly.

### Ruby Version Errors
* The project is written using Ruby 3.2.1, if you encounter issues upon cloning, make sure you have Ruby version 3.2.1 in your environment.


