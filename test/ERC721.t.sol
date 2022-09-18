// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC721.sol";

contract ERC721Test is Test {
    MyNFT public myNft;
    address bob = address(0x1);
    address simon = address(0x2);

    function setUp() public {
        myNft = new MyNFT();
    }
    function testMintToken() public {
      myNft.mint(bob, 0);
      address owner_of = myNft.ownerOf(0);
      assertEq(bob, owner_of);
    }
    function testTransferToken() public {
      vm.startPrank(bob);
      myNft.mint(bob, 0);
      myNft.safeTransferFrom(bob, simon, 0);
      address owner_of = myNft.ownerOf(0);
      assertEq(simon, owner_of);
    }

    function testGetBalance() public {
      myNft.mint(bob, 0);
      myNft.mint(bob, 1);
      myNft.mint(bob, 2);
      myNft.mint(bob, 3);
      myNft.mint(bob, 4);
      myNft.mint(bob, 5);
      uint256 balance = myNft.balanceOf(bob);
      assertEq(balance, 6);
    }

    function testBurnToken() public {
      myNft.mint(bob, 0);
      myNft.mint(simon, 1);
      vm.startPrank(simon);
      vm.expectRevert("not owner");
      myNft.burn(0);
      emit log_address(simon);
    }
}
