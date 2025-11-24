

import 'Status.dart';

class ApiResponse<T> {
  //Coming from eum class
  Status? status;
  //Dynamic function to take the data
  T? response;
  //message
  String? message;
  //constructor
  ApiResponse(this.status, this.response, this.message);

  //If data is loading then it'll take loading from status enum
  ApiResponse.loading() : status = Status.loading;
  ApiResponse.completed(this.response) : status = Status.completed;
  ApiResponse.error(this.message) : status = Status.error;
  //Override method
  @override
  String toString() {
    return "commandstatus : $status \n commandmessage : $message \n dataSet: $response";
  }
}
