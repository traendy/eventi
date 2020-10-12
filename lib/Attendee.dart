class Attendee{
  var id=-1;
  var firstName="";
  var lastName="";
  var speaks=false;

  Attendee(int id, String firstName, String lastName){
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
  }

  Attendee.speaker(int id, String firstName, String lastName, bool speaks) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.speaks = speaks;
  }

  getId(){
    return this.id;
  }

  getFirstName(){
    return this.firstName;
  }

  getLastName(){
    return this.lastName;
  }

  isSpeaker(){
    return this.isSpeaker;
  }
}