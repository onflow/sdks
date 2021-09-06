# Test Fixtures
The purpose of providing test fixtures is to ease the testing process and give you the confidence that your implementation is correct. 

## Usage
Fixtures are JSON files that should be fed to your tests containing input values and values to assert the output of your implementation.

**Example Usage**

Here is an example on how to test your RLP encoding implementation in javascript.
```js
const rlpData = require('../fixtures/crypto/rlp.json')

describe(`${rlpData.title}`, function() {
    
  for (const name in rlpData.tests) {
    it(`passes ${name}`, function(done) {
      const output = RLP.encode(rlpData.tests[name].in)
      assert.equal('0x' + output.toString('hex'), rlpData.tests[name].out.toLowerCase())
      done()
    })
  }
})
```