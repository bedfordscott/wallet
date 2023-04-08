# Haskell Cryptocurrency Wallet
- This is a simple command line interface program for managing a cryptocurrency wallet written in Haskell.

### Requirements
- GHC 8.10.7 or higher
- Cabal 3.4.0.0 or higher
- cryptonite library
### Installation
- bash
- git clone https://github.com/bedfordscott/wallet.git
- cd wallet
- cabal install --dependencies-only
- cabal build
### Usage
- bash
#### Generate a new key pair
- ./dist/build/cli/cli generate-keys

#### Send coins to a recipient
- ./dist/build/cli/cli send-coins [RECIPIENT] [AMOUNT]

#### Receive coins from a sender
- ./dist/build/cli/cli receive-coins [SENDER]

#### Show current balance
- ./dist/build/cli/cli show-balance
## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
This project was created by Ford Scott.
