You need to get your `Digital Ocean Access Token` to use `terraform`. To do this:
* Click `API` on the sidebar of the web console
* Click `Generate personal access token`

You will then see your token, you need to save it as when you refresh it will disapear forever.

I exported my token as an `ENV` var so I did not have to put it in any of my code.

```bash
export DIGITALOCEAN_ACCESS_TOKEN="xXxxXxxXxxXxxXxxXxxXxxXxxXxxXx"
```

> When I am on Windows I use a `terraform.tfvars` file with the TOKEN in it.

To deploy just `cd` into the `terraform` dir and run:

```bash
terraform apply --auto-approve
```