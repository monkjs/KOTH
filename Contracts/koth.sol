/* Kings of the Hill
/*
/* Version: 0.1.0
/*
/* Summary: Allow all donations to be recorded on the blockchain and have the baron who donates the most ethereum become the 'King of the Hill'.
/*
/* Goal: Teach students about solidity and ease there way into programing on the blockchain.
/*
/* Created By: monkJs @ www.monkjs.com
/*
*/
pragma solidity ^0.4.21;


contract KOTH {
  address public owner;
  address public king;

  uint public kingsBid = 0;

  mapping (address => uint) barons;

  event newKingHasBeenCrowned(address king, uint bid);
  event newDonationHasBeenMade(address donator, uint bid);


  /* -*--* MODIFIERS *--*- */
  modifier isOwner() {
    require(msg.sender == owner);
    _;
  }


  /* -*--* REASSIGNMENT *--*- */
  function reassignOwner(address newOwner) public isOwner {
    owner = newOwner;
  }


  /* -*--* OWNER FUNCTIONS *--*- */
  function cleanTheKingsChest() public isOwner {
    uint bal = address(this).balance;
    address(owner).transfer(bal);
  }


  /* -*--* KINGS FUNCTIONS *--*- */
  function claimKingship() public payable {
    barons[msg.sender] += msg.value;
    emit newDonationHasBeenMade(msg.sender, msg.value);
    if (barons[msg.sender] > kingsBid) {
      kingsBid = barons[msg.sender];
      king = msg.sender;
      emit newKingHasBeenCrowned(msg.sender, barons[msg.sender]);
    }
  }


  /* -*--* INITIALIZE *--*- */
  constructor() public {
    owner = msg.sender;
    king = owner;
  }
}
