
import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/paths.dart';
import '../../models/consultPackage.dart';
import '../../models/consultReview.dart';
import '../../models/setting.dart';
import '../../models/user.dart';
import '../../repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserDataRepository userDataRepository;
  AccountBloc({required this.userDataRepository}) : super(AccountInitial()) {
    on<GetLoggedUserEvent>((event, emit) async {
      emit (GetLoggedUserInProgressState());
      try {
        if(FirebaseAuth.instance.currentUser!=null){
          var ref = FirebaseFirestore.instance.collection(Paths.usersPath).doc(FirebaseAuth.instance.currentUser!.uid).withConverter(
            fromFirestore: GroceryUser.fromFirestore,
            toFirestore: (GroceryUser user, _) => user.toFirestore(), );
          final docSnap = await ref.get();
          GroceryUser? user = docSnap.data();
          if (user != null) {
            emit( GetLoggedUserCompletedState(user));
          }
          else {
            emit( GetLoggedUserFailedState());
          }
        }
        else {
          emit( GetLoggedUserFailedState());
        }

      } catch (e) {
        print(e);
        print(" Error GetAccountDetails4");
        emit( GetLoggedUserFailedState());
      }
    });
 /*   on<GetAccountDetailsEvent>((event, emit) async {
      emit (GetAccountDetailsInProgressState());
      try {
          var ref = FirebaseFirestore.instance.collection(Paths.usersPath).doc(event.uid).withConverter(
            fromMap: GroceryUser.fromMap,
            toFirestore: (GroceryUser user, _) => user.toFirestore(), );
          final docSnap = await ref.get();
          GroceryUser? user = docSnap.data();
          if (user != null) {
            emit( GetAccountDetailsCompletedState(user));
          }
          else {
            emit( GetAccountDetailsFailedState());
          }


      } catch (e) {
        print(e);
        print(" Error GetAccountDetails4");
        emit( GetAccountDetailsFailedState());
      }
    });*/
    //=========
    on<UpdateAccountDetailsEvent>((event, emit) async {
      emit (UpdateAccountDetailsInProgressState());
      try {
        bool isUpdated =await userDataRepository.updateAccountDetails(event.user, event.profileImage);
        if (isUpdated) {
          emit( UpdateAccountDetailsCompletedState());
        }
        else {
          emit( UpdateAccountDetailsFailedState());
        }


      } catch (e) {
        print(e);
        print(" Error UpdateAccountDetailsFailedState");
        emit( UpdateAccountDetailsFailedState());
      }
    });
  }



  @override
  AccountState get initialState => AccountInitial();

  /*@override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is GetAccountDetailsEvent) {
      yield* mapGetAccountDetailsEventToState(
        uid: event.uid,
      );
    }
    if (event is GetConsultPackagesEvent) {
      yield* mapGetConsultPackagesEventToState(
        uid: event.uid,
      );
    }
    if (event is GetConsultReviewsEvent) {
      yield* mapGetConsultReviewsEventToState(
        uid: event.uid,
      );
    }



    if (event is UpdateAccountDetailsEvent) {
      yield* mapUpdateAccountDetailsEventToState(
        user: event.user,
        profileImage: event.profileImage,
      );
    }


  }*/

  Stream<AccountState> mapGetConsultPackagesEventToState({required String uid}) async* {
    yield getConsultPackagesInProgressState();
    try {
      List<consultPackage>? packages = await userDataRepository.getConsultPackages(uid);
      if (packages != null) {

        yield getConsultPackagesCompletedState(packages);
      } else {
        yield getConsultPackagesFailedState();
      }
    } catch (e) {
      print(e);
      yield getConsultPackagesFailedState();
    }
  }

  Stream<AccountState> mapGetConsultReviewsEventToState({required String uid}) async* {
    yield getConsultReviewsInProgressState();
    try {
      List<ConsultReview>? reviews = await userDataRepository.getConsultReviewes(uid);
      if (reviews != null) {

        yield getConsultReviewsCompletedState(reviews);
      } else {
        yield getConsultReviewsFailedState();
      }
    } catch (e) {
      print(e);
      yield getConsultReviewsFailedState();
    }
  }
  Stream<AccountState> mapGetAccountDetailsEventToState({required String uid}) async* {
    yield GetAccountDetailsInProgressState();
    try {
      print("GetAccountDetails1");
      GroceryUser? user = await userDataRepository.getAccountDetails(uid);
      if (user != null) {
        print("GetAccountDetails2");

        yield GetAccountDetailsCompletedState(user);
      } else {
        print("GetAccountDetails3");

        yield GetAccountDetailsFailedState();
      }
    } catch (e) {
      print(e);
      print("GetAccountDetails4");

      yield GetAccountDetailsFailedState();
    }
  }




  Stream<AccountState> mapUpdateAccountDetailsEventToState(
      {required GroceryUser user, File? profileImage}) async* {
    yield UpdateAccountDetailsInProgressState();
    try {
      bool isUpdated =await userDataRepository.updateAccountDetails(user, profileImage);
      if (isUpdated) {
        yield UpdateAccountDetailsCompletedState();
      } else {
        yield UpdateAccountDetailsFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdateAccountDetailsFailedState();
    }
  }

}
