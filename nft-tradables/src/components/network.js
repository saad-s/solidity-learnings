
export default async function getNetworkDetails () {
    const networkId = await window.ethereum.request({
        method: 'eth_chainId',
    });
    console.log(networkId)
    return networkId
}