import './App.css';
import React, { useState } from 'react';
import isMetaMaskInstalled from './components/detectMetamask.js';
import MetaMaskAuth from './components/auth.js';
import GetContractDetails from './components/contract.js';

function App() {
  // user address 
  const [userAddress, setUserAddress] = useState('')

  // metasmask is required for app to run
  // TODO: handle it with a link to extension 
  if(!isMetaMaskInstalled()) {
    alert('Please install metamask')
    return
  }

  return (
    userAddress? (<div> 
      Connected as {userAddress}
      <GetContractDetails />
    </div>) :
    (<MetaMaskAuth onAddressChanged={setUserAddress} />)
  );
}

export default App;
