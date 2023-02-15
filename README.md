# In memory dynamic stack [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gha]: https://github.com/threesigmaxyz/foundry-template/actions
[gha-badge]: https://github.com/threesigmaxyz/foundry-template/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A dynamic memory stack implementation in solidity.


## Blueprint

```ml
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ openzeppelin-contracts — https://github.com/OpenZeppelin/openzeppelin-contracts
scripts
├─ 01_Deploy.s.sol — Simple Deployment Script
src
├─ InMemoryStack.sol — The library
test
└─ InMemoryStack.t.sol — Tests
```

## Usage

Here's a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ make build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ make clean
```

### Compile

Compile the contracts:

```sh
$ make build
```

### Test

To run all tests execute the following commad:

```
make tests
```

Alternatively, you can run specific tests as detailed in this [guide](https://book.getfoundry.sh/forge/tests).

## Benchmarking

In the test `testBenchmarkDynamicVsStatic()` the gas costs of the dynamic stack vs a fixed sized array are compared.

The gas cost is approximately the same when 1000 elements are declared in the static array, but only 100 elements are effectively added.

Thus, try to use static arrays whenever possible to reduce gas overload.

# About Us
[Three Sigma](https://threesigma.xyz/) is a venture builder firm focused on blockchain engineering, research, and investment. Our mission is to advance the adoption of blockchain technology and contribute towards the healthy development of the Web3 space.

If you are interested in joining our team, please contact us [here](mailto:info@threesigma.xyz).

---

<p align="center">
  <img src="https://threesigma.xyz/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fthree-sigma-labs-research-capital-white.0f8e8f50.png&w=2048&q=75" width="75%" />
</p>
