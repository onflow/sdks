<br />
<p align="center">
  <a href="https://docs.onflow.org/emulator/">
    <img src="./sdk-guidelines-banner.svg" alt="Logo" width="610" height="auto" />
  </a>

  <p align="center">
    <i>Guidelines and resources for building Flow SDKs and client libraries</i>
    <br />
    <a href="https://github.com/onflow/sdks/pulls"><strong>Suggest a Guideline»</strong></a>
    <br />
    <br />
    <a href="https://github.com/onflow/flow-emulator/issues">Suggest a Change</a>
    ·
    <a href="https://github.com/onflow/flow-emulator/blob/master/CONTRIBUTING.md">Contribute</a>
  </p>
</p>
<br />
<br />


_This repository defines guidelines for building Flow SDKs. It's still work in progress. It aims to help you build and maintain a high-quality Flow SDK._

The guidelines will help you build SDKs that will be:

### **Consistent**

Usage of ubiquitous language, supporting same user stories, common versioning will bring consistency across SDKs. Consistency is important as it brings familiarity between implementations, easier transitions, and a common practice for implementations. 

### **Accessible**

Accessibility is an important aspect of each SDK and it means how easy is for a developer to start using and implementing the SDK. Great documentation makes SDK more accessible. The guidelines define rules around the documentation and also example templates to write it. 

### **Reliable**

Reliability is of the highest importance for any piece of software. It is achieved by having good tests, but also and almost more importantly common rules around handling changes, and backward compatibility, since the SDK is not meant to act as a standalone product but as an integrated part in another product it is important that it doesn't break that piece of software. Changes are inevitable and we will provide guidance on how to tackle them without hurting anyone.

### **Community-driven**

We want SDKs to live and be owned by the community. We want them to evolve with the community usage and not be biased with our view of the problems.

# Process

We have divided the SDK implementation process into multiple steps. You can go through each step as you build your own SDK.

## Design

SDK should provide good isolation between domain functionalities, we believe that networking and cryptography shouldn't be implemented by you, but instead provide a common interface and leverage good and secure implementation of the third-party SDKs. There are multiple reasons behind this architectural decision:

- **security** - implementing your own cryptography functions can be too complex which might lead to mistakes that will be costly.
- **complexity** - leverage work from other libraries and this way lower the friction for implementing the SDK
- **maintainability** - cryptography operations can change and it is important to stay on top of those changes
- **testability** - isolating networking layer will give you an easier option to swap that part during testing with a mock implementation

    ![SDK Schema](schema-sdk.png)

Implementation of the SDK can implement arbitrary feature domains. A feature domain is a set of related features that define a common interface. Each language-specific implementation of the SDK can implement an arbitrary set of feature domains and be advertised as such thus removing the idea of one SDK per language to rule them all. The concepts of implementing different feature domains follow the philosophy of composability and "doing one thing and doing it well".

**Feature Domains [WIP]**

- **SDK** - Implementing access node API
- **FCL** - Wallet discovery

*NOTE: Ubiquitous langauge is work in progress: When designing an SDK interface it is advisable you follow our ubiquitous language, this will achieve the goal of consistency. You can read about the ubiquitous language here:
[SDK Ubiquitous Language](ubiquitous-language.md)*

## Implementation

Implementation of the SDK should be done by following user stories. Bellow-defined users stories are your guide to implementing a feature domain and we support you with test data and fixtures.

**Overview**

Building a full-featured SDK will involve a few steps:
- Access node client: enable connection to the emulator or any access node using GRPC or HTTP
- Encoding/decoding cadence: ability to parse results from cadence value to SDK objects and vice versa
- Transaction signing: implement signing in order to submit valid transactions
- Developer UX: implement validations, factory methods for different resources, offer templates, documentation

After communication with the access node is implemented the best way to proceed is to follow common user stories defined bellow:

**User Stories**

User stories are an implementation aid to guide you through implementing all the functionality for a full-featured SDK.  

Blocks:
- [ ] retrieve a block by ID
- [ ] retrieve a block by height
- [ ] retrieve the latest block

Collections:
- [ ] retrieve a collection by ID 

Events:
- [ ] retrieve events by name in the block height range

Scripts:
- [ ] submit a script and parse the response
- [ ] submit a script with arguments
- [ ] create a script that returns complex structure and parse the response

Accounts:
- [ ] retrieve an account by address
- [ ] create a new account
- [ ] deploy a new contract to the account
- [ ] remove a contract from the account
- [ ] update an existing contract on the account

Transactions: 
- [ ] retrieve a transaction by ID
- [ ] sign a transaction with same payer, proposer and authorizer
- [ ] sign a transaction with different payer and proposer
- [ ] sign a transaction with different authorizers using sign method multiple times
- [ ] submit a signed transaction
- [ ] sign a transaction with arguments and submit it


**Cryptography**

Cryptographic signing of transactions should be implemented with great care as this can present a huge security issue if done incorrectly. Our advice is to compose your SDK on top of existing cryptographic libraries that are tested and secure.
You should be familiar with the [signing process used on Flow](https://docs.onflow.org/concepts/accounts-and-keys/) and test your encoding implementation by using our test fixtures [provided here](/fixtures/README.md).

*When signing a transaction payload be mindful of the domain tag which needs to be prepended to the encoded payload before the signing process takes place.*  

**Networking**

Access nodes currently support two APIs:

- **HTTP**
    The HTTP API is available and the documentation [can be found here](https://docs.onflow.org/http-api/). The HTTP API is defined by the Open API schema which [can be found here](https://github.com/onflow/flow/tree/master/openapi) and can be used to generate client code.

- **GRPC**
    Implementing gRPC protocol can be done by using the [protobufs found here](https://github.com/onflow/flow/tree/master/protobuf) and by using [the documentation](https://docs.onflow.org/access-api/). You can read how to generate client resources from protobufs in [this tutorial](https://grpc.io/docs/languages/go/basics/#client). Using generated clients is advisable so you can leverage the encoding/decoding of the data. 

Communication with access nodes should be contained in a networking module exposing only an interface and thus isolating the implementation from the rest of the SDK. This will allow you to easily test the library by mocking the module, it will also allow you to change the API type if needed (migration from gRPC to HTTP will be easy), and make it possible for you to reuse third-party libraries. It's advisable to leverage popular third party libraries to do network communication as it  will provide faster and more secure implementation.

Executing network requests should provide a mechanism to control the request after being sent, this would allow the application using the SDK to cancel the request, set different timeouts, and in general give control to the user. Networking should be implemented in asynchronous or synchronous nature, based on what is idiomatic in the specific language but prefer asynchronous if possible.

**Versioning**

Changes in the codebase should reflect with versioning. We advise using [semantic versioning format](https://semver.org/). Following this versioning format will allow you to comply with other guidelines such as handling breaking changes etc. Once the codebase is stable enough you should establish a release schedule and make sure it always includes all changes from sporking.

**Cadence**

Implementing the above-mentioned user stories will require you to supply the transactions with a cadence code. To avoid making mistakes in the cadence code we advise you to use our templates defined in the repo [TBD]

[Cadence Templates](/templates/cadence)

**Error Handling**

Writing code by exercising [defensive design](https://en.wikipedia.org/wiki/Defensive_design) is a good way to avoid unexpected errors. Handle errors gracefully and in language idiomatic way. Provide the best context as part of the error message as you can, this will allow the user of the SDK to quickly debug the problem. 

**Logging**

Logging is an optional functionality of the SDK and it is meant to be of assistance to the developer implementing your SDK, however, please be careful that logging is implemented as an isolated module and it should be possible to disable it. It is advisable to also use third-party logging libraries which should be plugged into the SDK.

**Publishing**

Publish the SDK by using the standard package repository for the implementation language. This way the SDK will be easy to discover and install.

## Testing

Writing good tests is a crucial task in pursuit of reliability. We will assist you with our testing data by providing you some [fixtures you can find here](https://github.com/onflow/sdks/tree/main/fixtures). 

*WIP not available yet: After implementing unit tests you should add integration tests by using our testing mock APIs found here [TBD]. Mock API exposes the same API interface as the access node and returns mock results which you can assert.*

The SDK could expose the testing functionality. Doing so it would be possible for developers using the SDK to switch to mock implementation of the access APIs in the SDK and test their integration easier.

**CI & CD**

Follow best practices in optimizing the integration and deployment workflow. Make sure tests are being run as part of the CI and all released versions of the SDK are passing the tests.

## Documentation

We like to follow the philosophy of tasks not being done until they are documented. Our SDK documentation is built by using the documentation template.
[Documentation Template](/templates/documentation)

**Repository**

Each SDK should have a repository that contains the following documents: readme, contributing, and license. 

**Specifications**

Make sure you also generate specifications for your SDK public API, that specification should then be linked in the documentation template.
This requirement is to achieve better accessibility as described in the goals section. The codebase should be well-commented code and leverage specification generation tools available for each language. Try to use the standard or most popular specification syntax and generators. Generating specification based on comments will allow better understanding for people reading through source code, it will provide intellisense functionality in IDEs and will allow you to keep documentation updated without the need to change any texts in the docs as the references will be linked and updated.

## Maintaining

After releasing the first version of your SDK the maintenance period begins. Maintaining an SDK means implementing new features, removing features that are no longer supported and fixing potential bugs, and doing all of that without breaking others people's stuff. This guideline will provide tools and practices you can use during the maintenance period.

**Breaking Changes**

Breaking changes should always be documented, preferably should be part of the PR and it follows. Write the changelogs using the format described here [https://keepachangelog.com/en/1.0.0/](https://keepachangelog.com/en/1.0.0/).

You should communicate changes by providing answers to questions: how it breaks and what are the changes needed.

**Deprecation**

Before a breaking change happens there should be a period announcing the change if possible. After making a change try to support backward compatibility up to a period during which you should output a warning about the change. Try to define this period and keep it the same so developers become familiar with it.

