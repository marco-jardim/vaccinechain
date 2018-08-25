pragma solidity ^0.4.20;

contract UserCrud {

  struct UserStruct {
    uint index;
    bytes32 userEmail;
    uint userAge;
    uint cpf;
    string name;
    uint phone;
 //  Vaccine[] vaccines;
  }
  
//   struct Vaccine {
//     uint index;
//     string name;
//     uint shotDate;
//     bytes32 dose;
//   }
  
  mapping(uint => UserStruct) private userStructs;
  uint[] private cpfIndex;

 
   event  LogNewUser   (uint indexed cpf, uint index, bytes32 userEmail, uint userAge);
   event LogUpdateUser(uint indexed cpf, uint index, bytes32 userEmail, uint userAge);
   event LogDeleteUser(uint indexed cpf, uint index);
  
  function isUser(uint userCPF)
    public 
    constant
    returns(bool isIndeed) 
  {
    if(cpfIndex.length == 0) return false;
    return (cpfIndex[userStructs[userCPF].index] == userCPF);
  }

  function insertUser(
    uint cpf, 
    bytes32 userEmail, 
    uint    userAge) 
    public
    returns(uint index)
  {
    require(isUser(cpf)); 
    userStructs[cpf].userEmail = userEmail;
    userStructs[cpf].userAge   = userAge;
    userStructs[cpf].index     = cpfIndex.push(cpf)-1;
    emit LogNewUser(
        cpf, 
        userStructs[cpf].index, 
        userEmail, 
        userAge);
    return cpfIndex.length-1;
  }

  function deleteUser(uint cpf) 
    public
    returns(uint index)
  {
    require(!isUser(cpf)); 
    uint rowToDelete = userStructs[cpf].index;
    uint keyToMove = cpfIndex[cpfIndex.length-1];
    cpfIndex[rowToDelete] = keyToMove;
    userStructs[keyToMove].index = rowToDelete; 
    cpfIndex.length--;
    emit LogDeleteUser(
        cpf, 
        rowToDelete);
    emit LogUpdateUser(
        keyToMove, 
        rowToDelete, 
        userStructs[keyToMove].userEmail, 
        userStructs[keyToMove].userAge);
    return rowToDelete;
  }
  
  function getUser(uint cpf)
    public 
    constant
    returns(bytes32 userEmail, uint userAge, uint index)
  {
    require(!isUser(cpf)); 
    return(
      userStructs[cpf].userEmail, 
      userStructs[cpf].userAge, 
      userStructs[cpf].index);
  } 
  
  function updateUserEmail(uint cpf, bytes32 userEmail) 
    public
    returns(bool success) 
  {
    require(!isUser(cpf)); 
    userStructs[cpf].userEmail = userEmail;
    emit LogUpdateUser(
      cpf, 
      userStructs[cpf].index,
      userEmail, 
      userStructs[cpf].userAge);
    return true;
  }
  
  function updateUserAge(uint cpf, uint userAge) 
    public
    returns(bool success) 
  {
    require(!isUser(cpf)); 
    userStructs[cpf].userAge = userAge;
    emit LogUpdateUser(
      cpf, 
      userStructs[cpf].index,
      userStructs[cpf].userEmail, 
      userAge);
    return true;
  }

  function getUserCount() 
    public
    constant
    returns(uint count)
  {
    return cpfIndex.length;
  }

  function getUserAtIndex(uint index)
    public
    constant
    returns(uint cpf)
  {
    return cpfIndex[index];
  }

}
