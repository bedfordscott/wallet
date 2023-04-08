-- CLI.hs

module CLI
  ( Command(..)
  , runCommand
  ) where

import Options.Applicative
import Wallet

data Command
  = GenerateKeys
  | ShowBalance
  | SendCoins String Int
  | ReceiveCoins String

commandParser :: Parser Command
commandParser =
  subparser
    (  command "generate-keys" (info (pure GenerateKeys) (progDesc "Generate new key pair"))
    <> command "show-balance" (info (pure ShowBalance) (progDesc "Show current balance"))
    <> command "send-coins" (info sendCoinsParser (progDesc "Send coins to a recipient"))
    <> command "receive-coins" (info receiveCoinsParser (progDesc "Receive coins from a sender"))
    )

sendCoinsParser :: Parser Command
sendCoinsParser = SendCoins <$> argument str (metavar "RECIPIENT") <*> argument auto (metavar "AMOUNT")

receiveCoinsParser :: Parser Command
receiveCoinsParser = ReceiveCoins <$> argument str (metavar "SENDER")

runCommand :: Wallet -> Command -> IO ()
runCommand wallet GenerateKeys = do
  (publicKey, privateKey) <- generateKeyPair
  putStrLn $ "Public key: " ++ show publicKey
  putStrLn $ "Private key
