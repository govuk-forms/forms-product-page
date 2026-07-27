# Processing completed form submissions

GOV.UK Forms sends you form submissions as they are completed. You can receive the submissions in different ways, depending on how you want to process them.

## Get form submissions by email

By default, submissions are sent by email - from no-reply@forms.service.gov.uk
to the email address you nominate when creating the form. Any files you ask the user to upload are attached to the email.

Each submission is given a unique reference. The unique reference is included in the subject line and the body of the email.

Submission email subject lines use this format:

```markdown
Form submission: Form name - reference: 8E3YY3RX
```

The body of the email includes each of the questions asked in the form, followed by the answer the user has given for that question.

## Get form submissions as JSON or CSV email attachments

It may be easier to work with submission data in JSON or CSV format, for example if you’re planning to automate your form processing using a low code platform like MS Power Automate or Google Apps Script.

When you create or edit a form, you can opt to get submission data attached to the emails as a JSON or CSV file - as well as in the body of the email. Send yourself test submissions so you can see how emails are laid out and help set up your automation. You can view the [JSON schema for form submissions](https://www.forms.service.gov.uk/json-submissions/v1/schema).

## Get a daily or weekly CSV of completed forms

You can get a daily or weekly CSV file of all the submissions to a form from the previous day or week. You’ll continue to receive individual completed form submissions as usual. If your form has any file upload questions, the uploaded files will only be attached to the individual submissions. 

## Get form submissions in an AWS S3 bucket

If your organisation has access to the AWS stack, you can opt to receive form submissions in an AWS S3 bucket instead of by email. Submissions are written to the S3 bucket as individual JSON or CSV files.

If you want to receive form submissions in an AWS S3 bucket, [send us a support request](https://www.forms.service.gov.uk/support) confirming:

* that you have a technical team with access to the AWS stack, who can set up and maintain an S3 bucket on your behalf
* that you intend to configure the S3 bucket following relevant NCSC guidance (in particular the [cloud security guidance](https://www.ncsc.gov.uk/collection/cloud/using-cloud-services-securely/using-a-cloud-platform-securely) and [advice on configuring S3 buckets securely](https://www.ncsc.gov.uk/blog-post/theres-hole-my-bucket))
* whether you want to receive form submissions as JSON or CSV files
* whether you want us to switch off email submissions immediately - or whether you want to continue to receive submissions by email (for example, to make sure you do not miss any submissions while you’re moving from email submissions to S3 submissions)

Once you’ve raised the ticket, we’ll respond and tell you what permissions you need to give us so we can start writing data to your S3 bucket.

### Switching off email submissions

When you’re ready to switch off email submissions, [send us another support request](https://www.forms.service.gov.uk/support).

## Automatically forward email submissions to a different mailbox

If you need to route submissions to different email addresses based on an answer provided in the form, you may be able to configure your organisation’s email client so it does that for you. 

For example, MS Outlook allows you to [set up forwarding rules based on whether the email includes a specific keyword](https://support.microsoft.com/en-gb/office/use-rules-to-automatically-forward-messages-45aa9664-4911-4f96-9663-ece42816d746).

Bear in mind that MS Outlook forwarding rules will pick up any use of a keyword in the submission email - so MS Outlook could forward an email to the wrong place if a person uses the keyword in a way you do not expect. This is less of an issue with questions where you’re asking users to choose options from a list, because you can predict what text will appear in the submission email.

## Automate processing of email submissions

Some organisations are using low code platforms to automate processing of their form submissions. If you’re not sure whether your organisation supports use of a low code platform - or you need help setting up an automation - contact your organisation’s digital or IT team. Some organisations have a team which specialises in low code automation.

If your organisation supports MS Power Automate, the Microsoft website has [guidance on getting started with MS Power Automate](https://learn.microsoft.com/en-us/power-automate/flow-types). Or the Google website has [guidance on getting started with automations in Google Apps Script](https://developers.google.com/apps-script/quickstart/automation).

You can also [join the cross-government low code community](https://www.gov.uk/service-manual/communities/low-code-community).
