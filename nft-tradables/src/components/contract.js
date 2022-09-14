import GetNetworkDetails from './network.js';
import ERC721Tradables from '../nft-contracts/build/contracts/ERC721Tradables.json';
import { useEffect, useState } from 'react';


export default function GetContractDetails() {

  const [networkData, setNetworkData] = useState('')

  useEffect(() => {
    getNetworkData();
  }, []);

  async function getNetworkData() {
    const networkId = await GetNetworkDetails()
    const networkData = ERC721Tradables.networks[networkId]
    setNetworkData(JSON.stringify(networkData))
    console.log(networkId, networkData)
  }

  return <div>
      {networkData}
    </div>
}