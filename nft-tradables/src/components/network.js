
export default async function GetNetworkDetails () {
    const networkId = await window.ethereum.request({
        method: 'eth_chainId',
    });
    return networkId
}