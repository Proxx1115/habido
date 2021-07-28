import 'dart:convert';

import 'package:habido_app/models/base_request.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';

import 'api_helper.dart';
import 'api_manager.dart';
import 'api_routes.dart';

class ApiRouter {
  /// Authentication
  static Future<LoginResponse> login(LoginRequest request) async {
    Map<String, String> headers = ApiHelper.getHttpHeaders(hasAuthorization: false);
    headers.addAll(
      {"authorization": 'Basic ' + base64Encode(utf8.encode('${request.username}:${request.password}'))},
    );

    return LoginResponse.fromJson(await apiManager.sendRequest(
      path: ApiRoutes.signIn,
      headers: headers,
      hasAuthorization: true,
    ));
  }

// static Future<BaseResponse> signOut() async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.signOut,
//     requestData: BaseRequest(),
//   ))
//       .data);
// }
//
// static Future<BaseResponse> connectDevice(ConnectDeviceRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.connect,
//     requestData: request,
//   ))
//       .data);
// }
//
// static Future<SignUpResponse> signUp(SignUpRequest request) async {
//   return SignUpResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.signUp, requestData: request, hasSessionToken: false)).data);
// }
//
// static Future<BaseResponse> verify(VerifyRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.verify, requestData: request, hasSessionToken: false)).data);
// }
//
// static Future<SignUpResponse> forgotPass(ForgotPassRequest request) async {
//   return SignUpResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.forgotPass, requestData: request, hasSessionToken: false)).data);
// }
//
// static Future<BaseResponse> changePass(VerifyRequest request) async {
//   return BaseResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.changePassVerify, requestData: request, hasSessionToken: false)).data);
// }
//
// static Future<BaseResponse> changePassSettings(ChangePassRequest request) async {
//   return BaseResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.changePass, requestData: request, hasSessionToken: false)).data);
// }
//
// static Future<BonusBalResponse> getBonusBal() async {
//   var res = BonusBalResponse.fromJson(
//       (await apiManager.sendRequest(route: '/bonus-bal', requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data);
//
//   return res;
// }
//
// /// Check session
// static Future<UserData> getUserData() async {
//   // Req
//   var res = UserData.fromJson(
//     (await apiManager.sendRequest(
//       route: ApiRoutes.checkSession,
//       httpMethod: HttpMethod.Get,
//       requestData: BaseRequest(),
//     ))
//         .data,
//   );
//
//   try {
//     // Res
//     if (res.code == ResponseCode.Success) {
//       globals.userData = res;
//       globals.txnDate = Func.toDate(globals.userData.txnDate);
//     }
//   } catch (e) {
//     print(e);
//   }
//
//   return res;
// }
//
// static Future<CustImageResponse> custPhotos() async {
//   var res = CustImageResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.custPhotos,
//     httpMethod: HttpMethod.Get,
//     requestData: BaseRequest(),
//   ))
//       .data);
//
//   if (res.code == ResponseCode.Success) {
//     globals.custPicList = res.custPicList;
//     print('test');
//   }
//
//   // {"type":"https://tools.ietf.org/html/rfc7231#section-6.5.1","title":"One or more validation errors occurred.","status":400,"traceId":"|569ba6a0-450878699d492fad.","errors":{"PushNotifToken":["Токэн хоосон байна!"]}}
//
//   return res;
// }
//
// static Future<PrivateInfo> getCustPerson() async {
//   return PrivateInfo.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.custPerson, requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data);
// }
//
// static Future<BaseResponse> updateCustPerson(UpdatePrivateInfoRequest request) async {
//   return BaseResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.custPerson, requestData: request, httpMethod: HttpMethod.Put)).data);
// }
//
// static Future<GetDictListResponse> getDicts(GetDictListRequest request) async {
//   return GetDictListResponse.fromJson((await apiManager.sendRequest(
//       route: ApiRoutes.getDictList, dataType: DataType.List, data: request.dicts.toList(), requestData: BaseRequest()))
//       .data);
// }
//
// static Future<BaseResponse> uploadPhoto(UploadImageRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.uploadPhoto, requestData: request)).data);
// }
//
// static Future<GetAddressResponse> getAddresses() async {
//   return GetAddressResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.getAddresses, requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data);
// }
//
// static Future<BaseResponse> deleteAddress(int addrId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.deleteAddress.replaceAll('{addrId}', Func.toStr(addrId)),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Delete,
//   ))
//       .data);
// }
//
// static Future<BankAccountResponse> getBankAcntList() async {
//   var res = BankAccountResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.getBankAccounts, requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data);
//
//   if (res.code == ResponseCode.Success && res.bankAcntList != null && res.bankAcntList.length > 0) {
//     globals.bankAcntList = res.bankAcntList;
//   }
//
//   return res;
// }
//
// static Future<BaseResponse> addOrUpdateBankAccount(AddOrUpdateBankAcntRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.addOrUpdateBankAcnt, requestData: request)).data);
// }
//
// static Future<BaseResponse> deleteBankAcnt(int acntId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: '/cust/bank-acnt/' + Func.toStr(acntId),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Delete,
//   ))
//       .data);
// }
//
// static Future<GetFinanceInfoResponse> getFinanceInfo() async {
//   return GetFinanceInfoResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.financeInfo, requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data);
// }
//
// static Future<BaseResponse> updateFinanceInfo(UpdateFinanceInfoRequest request) async {
//   return BaseResponse.fromJson(
//       (await apiManager.sendRequest(route: ApiRoutes.financeInfo, requestData: request, httpMethod: HttpMethod.Put)).data);
// }
//
// static Future<BaseResponse> calculateLimit() async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.calculateLimit, requestData: BaseRequest())).data);
// }
//
// static Future<BaseResponse> getContract() async {
//   return BaseResponse.fromJson(
//     (await apiManager.sendRequest(
//       route: '/cust/contract',
//       requestData: BaseRequest(),
//       httpMethod: HttpMethod.Get,
//     ))
//         .data,
//   );
// }
//
// /// Вэб линкүүд
// static Future<ParamResponse> getParam() async {
//   var res = ParamResponse.fromJson(
//     (await apiManager.sendRequest(route: ApiRoutes.param, requestData: BaseRequest(), httpMethod: HttpMethod.Get)).data,
//   );
//
//   if (res.code == ResponseCode.Success) globals.params = res;
//   return res;
// }
//
// static Future<BaseResponse> contractRequest() async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.contractRequest, requestData: BaseRequest())).data);
// }
//
// static Future<GetDictResponse> getDict(GetDictRequest request) async {
//   return GetDictResponse.fromJson((await apiManager.sendRequest(
//       route: ApiRoutes.getDict + request.dict.type + "/" + request.dict.code,
//       requestData: BaseRequest(),
//       httpMethod: HttpMethod.Get,
//       queryParameter: request.filter != null ? {"filter": request.filter} : null))
//       .data);
// }
//
// static Future<BaseResponse> updateAddress(Address request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(route: ApiRoutes.updateAddress, requestData: request)).data);
// }
//
// static Future<ActiveLoansResponse> getAllLoans() async {
//   return ActiveLoansResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.allLoanAcnts,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<ActiveLoansResponse> getActiveLoans() async {
//   return ActiveLoansResponse.fromJson((await apiManager.sendRequest(
//     route: '/loan/active',
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> advanceLoan(AdvanceLoanRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: '/loan/adv', // ApiRoutes.advanceLoan,
//     requestData: request,
//     dataType: DataType.Object,
//   ))
//       .data);
// }
//
// static Future<NotifListResponse> notifList() async {
//   return NotifListResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.notifList,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> readNotif(String notifId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.readNotif + '/' + Func.toStr(notifId),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Put,
//   ))
//       .data);
// }
//
// static Future<LoanInfoResponse> loanInfo() async {
//   return LoanInfoResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanInfo,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BranchListResponse> branches() async {
//   return BranchListResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.branchs,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// /// Зээл төлөх
// static Future<LoanPayInfo> loanRepay(String acntNo) async {
//   var res = LoanPayInfo.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanRepay + '/' + Func.toStr(acntNo),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
//
//   if (res.hasQpay) {
//     try {
//       res.qpayV1Response = QPayV1Response.fromJson(jsonDecode(json.decode(res.qpayJson)));
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   return res;
// }
//
// /// Зээл сунгах
// static Future<LoanPayInfo> loanExtend(String acntNo) async {
//   var res = LoanPayInfo.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanExtend + '/' + Func.toStr(acntNo),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
//
//   if (res.hasQpay) {
//     try {
//       res.qpayV1Response = QPayV1Response.fromJson(jsonDecode(json.decode(res.qpayJson)));
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   return res;
// }
//
// static Future<BaseResponse> loanExtRequest(String acntNo) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanExtRequest + '/' + Func.toStr(acntNo),
//     requestData: BaseRequest(),
//   ))
//       .data);
// }
//
// static Future<BaseResponse> loanExtCancel(int reqId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanExtCancel + '/' + Func.toStr(reqId),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Put,
//   ))
//       .data);
// }
//
// static Future<LoanStatementResponse> getLoanStatement(String acntNo) async {
//   return LoanStatementResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanStatement.replaceAll('{acntNo}', acntNo),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> loanStatement(String acntNo) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.loanStatement.replaceAll('{acntNo}', acntNo),
//     requestData: BaseRequest(),
//   ))
//       .data);
// }
//
// static Future<ScrEmojiResponse> getScrEmojis() async {
//   return ScrEmojiResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrEmojis,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<ScrQuestionsResponse> getMainScrQuestions() async {
//   return ScrQuestionsResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrMainTest,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// // AdditionalScrQuestionsResponse
// static Future<ScrQuestionsResponse> getAdditionalScrQuestions() async {
//   return ScrQuestionsResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrAddTest,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> sendMainScoring(SendScoringRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrMainDone,
//     requestData: request,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> sendAdditionalScoring(SendScoringRequest request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrAddDone,
//     requestData: request,
//   ))
//       .data);
// }
//
// static Future<ScoringResultResponse> getScoringResult() async {
//   return ScoringResultResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.scrResult,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<RelativeListResponse> getRelativeList() async {
//   return RelativeListResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.relativeList,
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> addRelative(Relative relative) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.addRelative,
//     requestData: relative,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> deleteRelative(int relId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route:
//     // ApiRoutes.deleteRelative.replaceAll('{relId}', Func.toStr(relId)),
//     '/cust/rel/' + Func.toStr(relId),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Delete,
//   ))
//       .data);
// }
//
// static Future<BannerResponse> getSliderImages() async {
//   return BannerResponse.fromJson((await apiManager.simpleHttpRequest(
//     url: 'http://ser.zeely.mn/banners',
//   ))
//       .data);
// }
//
// static Future<BlogResponse> getBlogList() async {
//   return BlogResponse.fromJson((await apiManager.simpleHttpRequest(
//     url: 'http://ser.zeely.mn/blog-posts',
//   ))
//       .data);
// }
//
// static Future<DpAcntsResponse> getDpAcnts() async {
//   var res = DpAcntsResponse.fromJson((await apiManager.sendRequest(
//     // route: ApiRoutes.dpAcnts,
//     route: '/dp/acnts',
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
//
//   if (res.code == ResponseCode.Success) globals.dpAcntList = res.dpAcntList;
//
//   return res;
// }
//
// static Future<BaseResponse> dpWithdraw(DpWithdrawRequest request) async {
//   var res = BaseResponse.fromJson((await apiManager.sendRequest(
//     // route: ApiRoutes.dpWithdraw,
//     route: '/dp/with-draw',
//     requestData: request,
//     dataType: DataType.Object,
//     // data: request.toJson(),
//   ))
//       .data);
//
//   return res;
// }
//
// static Future<BaseResponse> payLoan(PayLoanRequest request) async {
//   var res = BaseResponse.fromJson((await apiManager.sendRequest(
//     // route: ApiRoutes.dpWithdraw,
//     route: '/dp/pay-loan',
//     requestData: request,
//     dataType: DataType.Object,
//     // data: request.toJson(),
//   ))
//       .data);
//
//   return res;
// }
//
// static Future<FriendListResponse> getInvitedFriends() async {
//   return FriendListResponse.fromJson((await apiManager.sendRequest(
//     route: '/cust/inv-friends?Pid=1&Psize=20&CustCode=' + Func.toStr(globals.userData?.custCode),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> inviteFriend(Friend request) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.inviteFriend,
//     requestData: request,
//   ))
//       .data);
// }
//
// static Future<BaseResponse> deleteFriend(int invId) async {
//   return BaseResponse.fromJson((await apiManager.sendRequest(
//     route: '/cust/inv-friend/' + Func.toStr(invId),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Delete,
//   ))
//       .data);
// }
//
// static Future<LoanPayInfo> loanPayExtAmt(double amount) async {
//   var res = LoanPayInfo.fromJson((await apiManager.sendRequest(
//     route: '/loan/pay-and-ext/' + Func.toStr(amount),
//     requestData: BaseRequest(),
//     httpMethod: HttpMethod.Get,
//   ))
//       .data);
//
//   if (res.hasQpay) {
//     try {
//       res.qpayV1Response = QPayV1Response.fromJson(jsonDecode(json.decode(res.qpayJson)));
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   return res;
// }
//
// static Future<BaseResponse> repayLoanInterestByBonus(RepayLoanInterestRequest request) async {
//   var res = BaseResponse.fromJson((await apiManager.sendRequest(
//     route: ApiRoutes.bonusRepayLnInt,
//     requestData: request,
//     dataType: DataType.Object,
//   ))
//       .data);
//
//   return res;
// }
}
