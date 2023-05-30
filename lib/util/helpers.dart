String removeLastWhiteSpace(String text) {

  List<String> textWithLastWhiteSpace = text.split("");

  if(textWithLastWhiteSpace [
    textWithLastWhiteSpace.length -1] == '') {
      textWithLastWhiteSpace.removeLast();
    }
  
  text = textWithLastWhiteSpace.join();

  return text;
}