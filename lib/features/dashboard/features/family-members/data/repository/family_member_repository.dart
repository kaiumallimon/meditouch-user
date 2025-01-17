import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/family-members/data/models/family_member_model.dart';

class FamilyMemberRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the Family Members collection
  CollectionReference get _familyMembersCollection =>
      _firestore.collection('db_client_family_members');

  /// Adds a family member to the list or creates a new document for the user if it doesn't exist.
  Future<bool> addFamilyMember(String userId, PersonModel person) async {
    try {
      // Check if the family member document for the user already exists
      final familyMemberDoc = await _familyMembersCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (familyMemberDoc.docs.isNotEmpty) {
        // If a document already exists, update the family members list
        final docId = familyMemberDoc.docs.first.id;
        final existingFamilyMember = FamilyMemberModel.fromMap(
            familyMemberDoc.docs.first.data() as Map<String, dynamic>, docId);

        // Add the new family member to the list of existing family members
        existingFamilyMember.familyMembers.add(person);

        // Update the document with the new family members list
        await _familyMembersCollection.doc(docId).update({
          'familyMembers':
              existingFamilyMember.familyMembers.map((x) => x.toMap()).toList(),
          'updatedAt': Timestamp.now(),
        });

        return true;
      } else {
        // If no document exists, create a new FamilyMemberModel document
        final newFamilyMember = FamilyMemberModel(
          id: _familyMembersCollection.doc().id,
          userId: userId,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          familyMembers: [person],
        );

        await _familyMembersCollection
            .doc(newFamilyMember.id)
            .set(newFamilyMember.toMap());

        return true;
      }
    } catch (e) {
      print('Error adding family member: $e');
      return false;

      // rethrow; // Rethrow the error to handle it at the calling place
    }
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      // Get the file from the image path
      File file = File(image.path);

      // Create a unique file name based on the current timestamp or image name
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to Firebase Storage location
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('family_members_images/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(file);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL after upload completes
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // get family members as stream
  Stream<FamilyMemberModel?> getFamilyMemberStream(String userId) {
    return _firestore
        .collection(
            "db_client_family_members") // Assuming collection name is 'familyMembers'
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Get the first document as an example
        var document = snapshot.docs.first;
        return FamilyMemberModel.fromMap(
          document.data(),
          document.id,
        );
      }
      // If no data is found, return an empty FamilyMemberModel
      return null;
    });
  }

  Future<FamilyMemberModel?> getFamilyMembersFuture(String userId) async {
    try {
      final snapshot = await _firestore
          .collection("db_client_family_members") // Assuming collection name is 'familyMembers'
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var document = snapshot.docs.first;
        return FamilyMemberModel.fromMap(
          document.data(),
          document.id,
        );
      }
      // If no data is found, return null
      return null;
    } catch (e) {
      // Handle any errors, maybe log or rethrow
      print("Error getting family member: $e");
      return null;
    }
  }



  // REMOVE a family member from the list by their email:

  // REMOVE a family member from the list by their email
  Future<bool> removeMember(String userId, String email) async {
    try {
      // Get the document where the userId matches
      final familyMemberDoc = await _familyMembersCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (familyMemberDoc.docs.isNotEmpty) {
        final docId = familyMemberDoc.docs.first.id;
        final existingFamilyMember = FamilyMemberModel.fromMap(
            familyMemberDoc.docs.first.data() as Map<String, dynamic>, docId);

        // Manually find the family member to remove by email
        PersonModel? memberToRemove;
        for (var member in existingFamilyMember.familyMembers) {
          if (member.email == email) {
            memberToRemove = member;
            break; // Break the loop once the member is found
          }
        }

        // Check if the member was found
        if (memberToRemove != null) {
          // Remove the member from the list
          existingFamilyMember.familyMembers.remove(memberToRemove);

          // Update the document with the updated list of family members
          await _familyMembersCollection.doc(docId).update({
            'familyMembers':
            existingFamilyMember.familyMembers.map((x) => x.toMap()).toList(),
            'updatedAt': Timestamp.now(),
          });

          return true;
        } else {
          // Member not found
          print('Member with email $email not found.');
          return false;
        }
      } else {
        // Family member document not found
        print('No family member document found for this user');
        return false;
      }
    } catch (e) {
      print('Error removing family member: $e');
      return false;
    }
  }

}
