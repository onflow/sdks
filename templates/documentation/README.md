# Documentation Templates
The purpose of providing documentation templates is to fast track the documentation process of your SDK. You should only provide code examples for each of the provided user story and those examples will be embedded in our [documentation website](https://docs.onflow.org/).

## Usage
Documents in this folder should be copied into your SDK top-level directory into the `documentation/examples` folder. You can use block comment on top of the example to provide an optional description that is specific for this example or language of the SDK. Feel free to have your own documentation files in the `documentation` folder, we will just use the files in the `examples` subfolder.

**Example Usage**

Here is a documentation example for javascript SDK:

File: `/documentation/examples/get-account.md`

```js
/*
Note: embed this in an async function. 
 */
const account = await fcl
    .send([fcl.getAccount(address)])
    .then(fcl.decode)
```