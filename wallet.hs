-- Wallet.hs

module Wallet
  ( Wallet(..)
  , generateKeyPair
  , signTransaction
  , verifySignature
  , Transaction(..)
  , TransactionHistory
  , sendTransaction
  , receiveTransaction
  , readPublicKey
  ) where

import Crypto.PubKey.ECC.Prim
import Crypto.PubKey.ECC.Generate
import Crypto.PubKey.ECC.Types
import Crypto.PubKey.ECC.ECDSA
import Data.Text.Encoding (encodeUtf8)
import Data.Aeson (ToJSON, encode)

data Wallet = Wallet
  { publicKey :: String
  , privateKey :: String
  , balance :: Int
  } deriving (Show)

generateKeyPair :: IO (PublicKey, PrivateKey)
generateKeyPair = do
  curve <- getCurveByName SEC_p256k1
  generate curve

signTransaction :: PrivateKey -> String -> Signature
signTransaction privateKey message =
  let hash = sha256 $ encodeUtf8 message
  in sign privateKey hash

verifySignature :: PublicKey -> String -> Signature -> Bool
verifySignature publicKey message signature =
  let hash = sha256 $ encodeUtf8 message
  in verify HashSHA256 publicKey signature hash

data Transaction = Transaction
  { from :: String
  , to :: String
  , amount :: Int
  , signature :: Signature
  } deriving (Show)

type TransactionHistory = [Transaction]

sendTransaction :: Wallet -> String -> Int -> IO Transaction
sendTransaction wallet to amount = do
  let message = from ++ to ++ show amount
      signature = signTransaction (privateKey wallet) message
      transaction = Transaction (publicKey wallet) to amount signature
  return transaction

receiveTransaction :: Wallet -> Transaction -> Maybe Transaction
receiveTransaction wallet transaction =
  if verifySignature (readPublicKey $ from transaction) (toJSON transaction) (signature transaction)
    then Just transaction
    else Nothing

readPublicKey :: String -> PublicKey
readPublicKey = read . dropWhile (/= ':')
