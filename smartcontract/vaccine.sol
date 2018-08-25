pragma solidity ^0.4.24;

contract UserCrud {

  struct UserStruct {
    uint index;
    string userEmail;
    uint userAge;
    uint cpf;
    string name;
    uint phone;
    uint dueDate;
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

 
   event LogNewUser   (uint indexed cpf, uint index, string userEmail, uint userAge, string name, uint phone, uint dueDate);
   event LogFullUpdate   (uint indexed cpf, uint index, string userEmail, uint userAge, string name, uint phone, uint dueDate);
   event LogUpdateUserEmail (uint indexed cpf, uint index, string userEmail);
   event LogUpdateUserDueDate (uint indexed cpf, uint index, uint dueDate);
   event LogUpdateUserAge (uint indexed cpf, uint index, uint age);
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
    string userEmail, 
    uint    userAge, 
    string name, 
    uint phone, 
    uint dueDate) 
    public
    returns(uint index)
  {
    require(!isUser(cpf)); 
    userStructs[cpf].userEmail = userEmail;
    userStructs[cpf].userAge   = userAge;
    userStructs[cpf].name   = name;
    userStructs[cpf].phone   = phone;
    userStructs[cpf].dueDate   = dueDate;
    userStructs[cpf].index     = cpfIndex.push(cpf)-1;
    emit LogNewUser(
        cpf, 
        userStructs[cpf].index, 
        userEmail, 
        userAge, 
        name, 
        phone, 
        dueDate);
    return cpfIndex.length-1;
  }

  function deleteUser(uint cpf) 
    public
    returns(uint index)
  {
    require(isUser(cpf)); 
    uint rowToDelete = userStructs[cpf].index;
    uint keyToMove = cpfIndex[cpfIndex.length-1];
    cpfIndex[rowToDelete] = keyToMove;
    userStructs[keyToMove].index = rowToDelete; 
    cpfIndex.length--;
    emit LogDeleteUser(
        cpf, 
        rowToDelete);
    emit LogFullUpdate(
        keyToMove, 
        rowToDelete, 
        userStructs[keyToMove].userEmail, 
        userStructs[keyToMove].userAge,
        userStructs[keyToMove].name,
        userStructs[keyToMove].phone,
        userStructs[keyToMove].dueDate);
    return rowToDelete;
  }
  
  function getUser(uint cpf)
    public 
    constant
    returns(string userEmail, uint userAge, string name, uint phone, uint dueDate, uint index)
  {
    require(isUser(cpf)); 
    return(
      userStructs[cpf].userEmail, 
      userStructs[cpf].userAge,
      userStructs[cpf].name,
      userStructs[cpf].phone,
      userStructs[cpf].dueDate,
      userStructs[cpf].index);
  } 
  
  function updateUserEmail(uint cpf, string userEmail) 
    public
    returns(bool success) 
  {
    require(isUser(cpf)); 
    userStructs[cpf].userEmail = userEmail;
    emit LogUpdateUserEmail(
      cpf, 
      userStructs[cpf].index,
      userEmail);
    return true;
  }
  
  function updateDueDate(uint cpf, uint dueDate) 
    public
    returns(bool success) 
  {
    require(isUser(cpf)); 
    userStructs[cpf].dueDate = dueDate;
    emit LogUpdateUserDueDate(
      cpf, 
      userStructs[cpf].index,
      dueDate);
    return true;
  }

  function updateUserAge(uint cpf, uint userAge) 
    public
    returns(bool success) 
  {
    require(isUser(cpf)); 
    userStructs[cpf].userAge = userAge;
    emit LogUpdateUserAge(
      cpf, 
      userStructs[cpf].index, 
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
