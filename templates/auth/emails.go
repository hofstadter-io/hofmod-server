package auth

const accountRegisterEmail = `
Hello from hofmod-server Example App!

Please click the following link to confirm your account.

http://localhost:1323/acct/confirm?token=%s
`

const accountConfirmEmail = `
Thank you for confirming your hofmod-server Example App account.

You can now use the app and api!
`

const passwordResetEmail = `
Hello from hofmod-server Example App!

Paste the following link in your browser and <b>ADD A PASSWORD</b> to the end.

http://localhost:1323/auth/password/reset?token=%s&password=
`
