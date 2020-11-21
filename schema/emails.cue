package schema

DefaultEmails: {
	AccountRegisterEmail: string | *"""
	Hello {{ .Email }},

	Welcome to the hofmod-server Example App!

	Please click the following link to confirm your account.

	http://localhost:1323/acct/confirm?token={{ .Token }}
	"""

	AccountConfirmEmail: string | *"""
	Thank you for confirming your hofmod-server Example App account.

	You can now use the app and api!
	"""

	PasswordResetEmail: string | *"""
	Hello {{ .Email }},

	Paste the following link in your browser and <b>ADD A PASSWORD</b> to the end.

	http://localhost:1323/auth/password/reset?token={{ .Token }}&password=
	"""

	PasswordChangedEmail: string | *"""
	Your password has been successfully changed.

	If this was an error, please reply to this email.
	"""
}
