import React, { Component } from 'react'

class Unconnected extends Component {

  render() {
    return (
      <div className="content unconnected">
        <div className="vertical-split">
            <h2>Add <a href="https://metamask.io/">MetaMask</a> as a browser extension</h2>
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/1200px-MetaMask_Fox.svg.png"></img>
        </div>
        <div className="vertical-split">
            <h2>Switch to a Kovan Ether Test Network</h2>
            <img src="https://miro.medium.com/max/726/1*wdfC5qEe9IBfceyblMzxCw.png"></img>
        </div>
      </div>
    )
  }
}

export default Unconnected;
