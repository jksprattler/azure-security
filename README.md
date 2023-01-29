## Contents

- `/azure-dev-infra` contains terraform artifacts for general infrastructure related to dev deployments associated with directories within this repo.
- `/azuread-users-groups-roles` contains the terraform artifacts for implementing Azure AD Users, Groups (dynamic) and Roles allowing you to implement Identity Governance using IAM as code. Link to runbook instructions [here](https://jksprattler.github.io/jennas-runbooks/Azure/azure-tf-ad-rbac.html) which includes a YouTube demo of the implementation.
- `/azuread-users-groups-roles-pt2` is a revisit of the previous runbook for implementing Azure AD Users, Groups and Roles by following this [HashCorp](https://developer.hashicorp.com/terraform/tutorials/azure/azure-ad) doc which utilizes a for_each loop through a list of users in a csv file. Also included are steps to create the GH Actions SPN using Terraform and further limiting privileges by allowing only Read access across the subscription rather than Owner. The SPN API permissions are also now managed via Terraform. Link to runbook instructions [here]((https://jksprattler.github.io/jennas-runbooks/Azure/azure-tf-ad-rbac-pt2.html) which includes a YouTube demo of the implementation.
