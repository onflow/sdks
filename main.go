package templates

import _ "embed"

//go:embed templates/cadence/add-account-key.cdc
var AddAccountKey string

//go:embed templates/cadence/add-contract.cdc
var AddContract string

//go:embed templates/cadence/create-account.cdc
var CreateAccount string

//go:embed templates/cadence/remove-account-key.cdc
var RemoveAccountKey string

//go:embed templates/cadence/remove-contract.cdc
var RemoveContract string

//go:embed templates/cadence/update-contract.cdc
var UpdateContract string
