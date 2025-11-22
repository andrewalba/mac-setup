# 🐙 Secure Github Setup

The following instructions assume that you have already installed the necessary git software.

1. Setup GIT

Add Username and Email to git

```bash
git config --global user.name <USERNAME> &&
git config --global user.email <EMAIL>
```

Ensure username/email were setup correctly 

```bash
git config --global --list
```

2. Setup GPG Commit Signing

GPG was installed in the General Installation script. GPG is a security standard to encrypt and secure code commits

Create config files for gpg and the gpg-agent. The agent will make sure you don’t have to type in your GPG passphrase for every commit.

```bash
mkdir ~/.gnupg
touch ~/.gnupg/gpg.conf ~/.gnupg/gpg-agent.conf
```

Open the `gpg.conf` file and add:

```
use-agent
```

In `gpg-agent.conf`, add the following lines to make sure your credentials are ‘kept alive’

```bash
default-cache-ttl 34560000
max-cache-ttl 34560000
```

Add the following lines to `~/.zshrc`

```bash
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent
```

To see the effects, restart the terminal or run the following

```bash
source ~/.zshrc
```

The GPG environment is now setup. Let’s now create a GPG signing key

```bash
gpg --full-gen-key
```

A wizard is printed to your terminal. You should configure as follows:

- Kind of key: 4 (RSA, sign only)
- Keysize: 4096
- Expiration: 2y (your key will expire after 2 years; you should set a reminder somewhere)
- Real name: <your github username>
- Email address: <your email address>


**Note**: _It is recommended setting your email address to your 'noreply' GitHub address: username@users.noreply.github.com. You can find your email address on the GitHub Email settings page._

Enter a strong password

To check if your GPG key is setup correctly run

```bash
echo 'it works' | gpg --clearsign
```

You should see a response similar to 

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

it works
-----BEGIN PGP SIGNATURE-----
<many characters>
-----END PGP SIGNATURE-----
```

We need to add your key to your git config, and to GitHub.

The (short) ID uses the last 8 characters of the key that was printed to the terminal before. You can retrieve it by running:

```bash
$ gpg --list-secret-keys --keyid-format SHORT
```

Outputs:

```
/Users/username/.gnupg/pubring.kbx
----------------------------------
sec   rsa4096/56667778 2021-11-12 [SC] [expires: 2023-11-12]
      AAABBBCCCDDDEEEFFF1112223334445556667778
uid         [ultimate] username <username@users.noreply.github.com>
```

The 56667778 bit after rsa4096/ is your short key ID. We need it to configure Git to sign commits and tags. Replace the user.signingkey value below with your own key ID:

```bash
$ git config --global user.signingkey 56667778
$ git config --global commit.gpgSign true
$ git config --global tag.gpgSign true
```

Add your public GPG key to GIT. Again, make sure to replace the ID with your own ID. The following will copy the public key to your clipboard. (ignore directory security notice)

```bash
$ gpg --armor --export 56667778 | pbcopy
```

Go to the [GitHub SSH and GPG keys](https://github.com/settings/keys) section

- Click [New GPG key] and paste into the box.
- Click [Add GPG key], and you’re done!

## Setup SSH Signing

SSH lets Github know that you are indeed who you say you are.

### Setup

Ensure you do not have any SSH keys already setup

```bash
ls -al ~/.ssh
```

Create a new SSH key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Enter the path to save the SSH key

If you want to save your new SSH key pair with a different name, you can copy what is inside the parenthesis (Users/you/.ssh/id_ed25519) and then add to it like so (Users/you/.ssh/id_ed25519_github)

If you get an error saying `~/.ssh does not exist`, then create one:

```bash
mkdir ~/.ssh
```

Enter a strong password for your Key

New keys should now be generated in `~/.ssh`

- `id_ed25519_github`
- `id_ed25519_github.pub`

Add the key to SSH Agent so that you don't have to enter the password every time.

```bash
exec ssh-agent zsh
```

Add the private key to the agent

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github
```

Setup Config File

```bash
touch ~/.ssh/config
```

Open the config file and paste the following:

```bash
Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_ed25519_github
```
Add SSH key to Github

Copy the key to your clipboard

```bash
pbcopy < ~/.ssh/id_ed25519_github.pub
```

Go to the [GitHub SSH and GPG keys](https://github.com/settings/keys) section

- Click [New SSH key] and paste into the box.
- Add a descriptive title
- Click [Add SSH key], and you’re done!