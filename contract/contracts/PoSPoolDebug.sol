//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./PoSPool.sol";
import "./mocks/IStaking.sol";
import "./mocks/IPoSRegister.sol";
import "./VotePowerQueue.sol";

/// This use mock contracts to replace the real PoS contracts.
/// Which enable developer test it in ethereum
contract PoSPoolDebug is PoSPool {
  
  IMockStaking private STAKING;
  IMockPoSRegister private POS_REGISTER;

  constructor(address _stakingAddress, address _posRegisterAddress) {
    STAKING = IMockStaking(_stakingAddress);
    POS_REGISTER = IMockPoSRegister(_posRegisterAddress);
  }

  function _stakingDeposit(uint256 _amount) public override {
    STAKING.deposit{value: _amount}(_amount);
  }

  function _stakingWithdraw(uint256 _amount) public override {
    STAKING.withdraw(_amount);
  }

  function _posRegisterRegister(
    bytes32 indentifier,
    uint64 votePower,
    bytes calldata blsPubKey,
    bytes calldata vrfPubKey,
    bytes[2] calldata blsPubKeyProof
  ) public override {
    POS_REGISTER.register(indentifier, votePower, blsPubKey, vrfPubKey, blsPubKeyProof);
  }

  function _posRegisterIncreaseStake(uint64 votePower) public override {
    POS_REGISTER.increaseStake(votePower);
  }

  function _posRegisterRetire(uint64 votePower) public override {
    POS_REGISTER.retire(votePower);
  }

  receive() external payable {}

  function _userInOutQueue(address _address, bool inOrOut) public view returns (VotePowerQueue.QueueNode[] memory) {
    VotePowerQueue.InOutQueue storage q;
    if (inOrOut) {
      q = userInqueues[_address];
    } else {
      q = userOutqueues[_address];
    }
    uint64 qLen = q.end - q.start;
    VotePowerQueue.QueueNode[] memory nodes = new VotePowerQueue.QueueNode[](qLen);
    uint64 j = 0;
    for(uint64 i = q.start; i < q.end; i++) {
      nodes[j++] = q.items[i];
    }
    return nodes;
  }

  function _rewardSections() public view returns (RewardSection[] memory) {
    return rewardSections;
  }

  function _votePowerSections(address _address) public view returns (VotePowerSection[] memory) {
    return votePowerSections[_address];
  }

  function _lastRewardSection() public view returns (RewardSection memory) {
    return rewardSections[rewardSections.length - 1];
  }

  function _lastVotePowerSection(address _address) public view returns (VotePowerSection memory) {
    return votePowerSections[_address][votePowerSections[_address].length - 1];
  }

  function _userShot(address _address) public view returns (UserShot memory) {
    return lastUserShots[_address];
  }

  function _poolShot() public view returns (PoolShot memory) {
    return lastPoolShot;
  }

}