//
//  ALObseObject.m
//  AFNetworking
//
//  Created by EmvigoSuperMac on 09/03/18.
//

#import "ALObseObject.h"
#import "ALObseCommon.h"
#import <AFNetworking/AFURLSessionManager.h>
#import <AFNetworking/AFNetworking.h>

@implementation ALObseObject






- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties..
    [encoder encodeObject:self.groupId1 forKey:ObseGroupId1];
    [encoder encodeObject:self.groupName1 forKey:ObseGroupName1];
    [encoder encodeObject:self.appLGroupId1 forKey:ObseAppLGroupId1];
    [encoder encodeObject:self.groupMembers1 forKey:ObseGroupMembers1];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        //decode properties..
        self.groupId1=[decoder decodeObjectForKey:ObseGroupId1];
        self.groupName1=[decoder decodeObjectForKey:ObseGroupName1];
        self.appLGroupId1=[decoder decodeObjectForKey:ObseAppLGroupId1];
        self.groupMembers1=[decoder decodeObjectForKey:ObseGroupMembers1];
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    
    self = [super init];
    if (self == nil) return nil;
    self.groupId1=[dictionary objectForKey:ObseGroupId1];
    self.groupName1=[dictionary objectForKey:ObseGroupName1];
    self.appLGroupId1=[dictionary objectForKey:ObseAppLGroupId1];
    self.groupMembers1=[dictionary objectForKey:ObseGroupMembers1];
    
    return self;
}

static NSOperationQueue *getMeetingGroupRequest;
static NSOperationQueue *addGroupRequest;
static NSOperationQueue *updateGroupRequest;
static NSOperationQueue *removeGroupRequestMember;
static NSOperationQueue *deleteGroupRequest;

+ (void)getGroupMembers:(NSString*)userName friendName:(NSString*)friendName catId:(NSString*)catId groupId:(NSString*)groupId meetingId:(NSString*)meetingId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    // calling a nil block will crash, so convert it to an empty block, which is safe to call, but does nothing
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        //success = ^(int successFlag, NSString *userName, NSString *password,int autosave, NSString *welcomeStat){};
    }
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"friendName":friendName,@"catid":catId,@"groupId":groupId,@"meetingID":meetingId,@"deviceId":deviceId};
    
    [getMeetingGroupRequest cancelAllOperations];
 //   if([ObseCommon isNetworkConnected])
//    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        getMeetingGroupRequest=manager.operationQueue;
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://staging-connect.obsequium.in/api/GetMeetingMembers" parameters:parameters error:nil];
        NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                        {
                                            
                                            NSDictionary *responseValue=(NSDictionary *)responseObject;
                                            //NSLog(@"res %@",responseValue);
                                            BOOL status = [[responseObject valueForKey:@"status"] boolValue];
                                            //      BOOL status = 0;
                                            if(status==0) {
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                success(responseObject);
                                                
                                            } else {
                                                
                                                NSArray *contactArr=[responseValue objectForKey:@"groups"];
                                                //NSMutableDictionary *contactDict=[responseValue objectForKey:@"Memebers"];
                                                //NSLog(@"bbbb  %@",[responseValue objectForKey:@"Memebers"]);
                                                for(int i=0;i<contactArr.count;i++)
                                                {
                                                    NSDictionary *contactListDict=contactArr[i];
                                                    ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:contactListDict];
                                                    
                                                    //                                                [[NSUserDefaults standardUserDefaults] setObject:contactArr forKey:@"membersListArray"];
                                                    success(obj);
                                                }
                                                
                                                
                                                
                                                
                                                if (error) {
                                                    NSLog(@"Error: %@", error);
                                                }
                                                else
                                                {
                                                    NSLog(@"Error: %@", error);
                                                   // failure([ObseCommon getMessageForErrorCode:-1004]);
                                                    
                                                }
                                            }
                                        }];
        
        [dataTask resume];
        
//    }
}

+ (void)addGroup:(NSString*)userName groupName:(NSString*)groupName groupId:(NSString*)groupId entityID:(NSString*)entityID appLozicGroupID:(NSString*)appLozicGroupID Members:(NSString*)Members  deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    // calling a nil block will crash, so convert it to an empty block, which is safe to call, but does nothing
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        //success = ^(int successFlag, NSString *userName, NSString *password,int autosave, NSString *welcomeStat){};
    }
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupName":groupName,@"groupId":groupId,@"entityID":entityID,@"appLozicGroupID":appLozicGroupID,@"Members":Members,@"deviceId":deviceId};
    
    [addGroupRequest cancelAllOperations];
 //   if([ObseCommon isNetworkConnected])
  //  {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        addGroupRequest=manager.operationQueue;
        
        
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://staging-connect.obsequium.in/api/ManageGroup" parameters:parameters error:nil];
        
        NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                        {
                                            
                                            
                                            NSDictionary *responseValue=(NSDictionary *)responseObject;
                                            NSLog(@"responseValue %@",responseValue);
                                            
                                            BOOL status = [[responseObject valueForKey:@"status"] boolValue];
                                            //      BOOL status = 0;
                                            if(status==0) {
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                success(responseObject);
                                                
                                            } else {
                                                
                                                if([[[responseValue objectForKey:@"status"] stringValue] isEqualToString:@"1"])
                                                {
                                                    ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:responseValue];
                                                    success(obj);
                                                }
                                                
                                                
                                                if (error) {
                                                    NSLog(@"Error: %@", error);
                                                }
                                                else
                                                {
                                                    NSLog(@"ERROR");
                                                   // failure([ObseCommon getMessageForErrorCode:-1004]);
                                                    
                                                }
                                            }
                                        }];
        
        [dataTask resume];
        
        
  //  }
    
}

+ (void)updateGroup:(NSString*)userName groupId:(NSString*)groupId groupName:(NSString*)groupName deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure
{
    // calling a nil block will crash, so convert it to an empty block, which is safe to call, but does nothing
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        //success = ^(int successFlag, NSString *userName, NSString *password,int autosave, NSString *welcomeStat){};
    }
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupId":groupId,@"groupName":groupName,@"deviceId":deviceId};
    
    [updateGroupRequest cancelAllOperations];
 //   if([ObseCommon isNetworkConnected])
   // {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        updateGroupRequest=manager.operationQueue;
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://staging-connect.obsequium.in/api/UpdateGroupName" parameters:parameters error:nil];
        NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                        {
                                            
                                            NSDictionary *responseValue=(NSDictionary *)responseObject;
                                            
                                            BOOL status = [[responseObject valueForKey:@"status"] boolValue];
                                            //      BOOL status = 0;
                                            if(status==0) {
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                success(responseObject);
                                                
                                            } else {
                                                
                                                if([[[responseValue objectForKey:@"status"] stringValue] isEqualToString:@"1"])
                                                {
                                                    success(responseValue);
                                                }
                                                
                                                
                                                
                                                
                                                if (error) {
                                                    NSLog(@"Error: %@", error);
                                                }
                                                else
                                                {
                                                    NSLog(@"ERROR");
                                                   // failure([ObseCommon getMessageForErrorCode:-1004]);
                                                    
                                                }
                                            }
                                        }];
        
        [dataTask resume];
        
  //  }
}

+ (void)removeGroupMember:(NSString*)userName groupId:(NSString*)groupId toUserUniqueId:(NSString*)toUserUniqueId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    // calling a nil block will crash, so convert it to an empty block, which is safe to call, but does nothing
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        //success = ^(int successFlag, NSString *userName, NSString *password,int autosave, NSString *welcomeStat){};
    }
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupId":groupId,@"toUserUniqueId":toUserUniqueId,@"deviceId":deviceId};
    
    [removeGroupRequestMember cancelAllOperations];
 //   if([ObseCommon isNetworkConnected])
 //   {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        removeGroupRequestMember=manager.operationQueue;
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://staging-connect.obsequium.in/api/RemoveGroupMember" parameters:parameters error:nil];
        NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                        {
                                            
                                            NSDictionary *responseValue=(NSDictionary *)responseObject;
                                            
                                            BOOL status = [[responseObject valueForKey:@"status"] boolValue];
                                            //      BOOL status = 0;
                                            if(status==0) {
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                success(responseObject);
                                                
                                            } else {
                                                
                                                NSArray *contactArr=[responseValue objectForKey:@"groups"];
                                                
                                                for(int i=0;i<contactArr.count;i++)
                                                {
                                                    NSDictionary *contactListDict=contactArr[i];
                                                    ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:contactListDict];
                                                    
                                                    
                                                    success(obj);
                                                }
                                                
                                                
                                                
                                                
                                                if (error) {
                                                    NSLog(@"Error: %@", error);
                                                }
                                                else
                                                {
                                                    NSLog(@"Error");
                                                   // failure([ObseCommon getMessageForErrorCode:-1004]);
                                                    
                                                }
                                                
                                            }
                                        }];
        
        [dataTask resume];
        
  //  }
}

+ (void)deleteGroupMember:(NSString*)userName groupUniqueId:(NSString*)groupUniqueId deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure
{
    // calling a nil block will crash, so convert it to an empty block, which is safe to call, but does nothing
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        //success = ^(int successFlag, NSString *userName, NSString *password,int autosave, NSString *welcomeStat){};
    }
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupUniqueId":groupUniqueId,@"deviceId":deviceId};
    
    [deleteGroupRequest cancelAllOperations];
 //   if([ObseCommon isNetworkConnected])
  //  {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        deleteGroupRequest=manager.operationQueue;
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://staging-connect.obsequium.in/api/DeleteGroup" parameters:parameters error:nil];
        NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                        {
                                            
                                            NSDictionary *responseValue=(NSDictionary *)responseObject;
                                            
                                            BOOL status = [[responseObject valueForKey:@"status"] boolValue];
                                            //      BOOL status = 0;
                                            if(status==0) {
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                success(responseObject);
                                                
                                            } else {
                                                
                                                if([[responseValue objectForKey:@"message"]isEqualToString:@"Deleted"])
                                                {
                                                    success(responseValue);
                                                }
                                                
                                                if (error) {
                                                    NSLog(@"Error: %@", error);
                                                }
                                                else
                                                {
                                                    NSLog(@"error");
                                                  //  failure([ObseCommon getMessageForErrorCode:-1004]);
                                                    
                                                }
                                            }
                                        }];
        
        [dataTask resume];
        
  //  }
}



@end
