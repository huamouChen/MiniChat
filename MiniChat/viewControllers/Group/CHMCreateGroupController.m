//
//  CHMCreateGroupController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/4.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMCreateGroupController.h"
#import "RCUnderlineTextField.h"
#import "CHMFriendModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface CHMCreateGroupController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *addImg;
@property (weak, nonatomic) IBOutlet RCUnderlineTextField *nameTextField;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation CHMCreateGroupController


/**
 点击群组头像
 
 @param sender 点击的手势
 */
- (IBAction)tapGroupImageView:(UITapGestureRecognizer *)sender {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    // 可编辑
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    UIAlertController *alertController = [[UIAlertController alloc] init];
    // 取消
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:self.imagePickerController completion:nil];
    }];
    // 拍照
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    // 从相册选择
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker];
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 使用相机拍照
 */
- (void)showCamera {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        // 没有权限
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else {
        // 是否支持相机功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        } else {
            [CHMProgressHUD showErrorWithInfo:@"相机功能不可用"];
        }
    }
}
/**
 从相册选择
 */
- (void)showImagePicker {
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    //    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == PHAuthorizationStatusDenied || authorizationStatus == PHAuthorizationStatusRestricted) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        } else {
            [CHMProgressHUD showErrorWithInfo:@"相册功能不可用"];
        }
    }
}

#pragma mark - image Picker controller delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:self.imagePickerController completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 隐藏picker controller
    [self imagePickerControllerDidCancel:picker];
    // 获取选择的照片
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.addImg.image = selectedImage;
}

/**
 点击创建群组按钮
 */
- (IBAction)createGroupButtonClick {
    NSArray *groupMemberArray = [self dealWithGroupMemberId];
//    [CHMHttpTool createGroupWtihGroupName:_nameTextField.text
//                             groupMembers:groupMemberArray
//                            groupPortrait:_addImg.image
//                                  success:^(id response) {
//                                      NSLog(@"---------%@", response);
//                                  } failure:^(NSError *error) {
//                                      [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"%zd", error.code]];
//                                  }];
    
    // 参数
//    NSString *groupOwner = [[NSUserDefaults standardUserDefaults] valueForKey:KAccount];
//    NSData *imgData = UIImageJPEGRepresentation(_addImg.image, 0.5);
//    NSDictionary *params = @{@"GroupName": _nameTextField.text, @"GroupImgStream": imgData, @"Members":groupMemberArray };
//    [CHMHttpTool postWithURLString:CreateGroupURL params:params image:_addImg.image imageName:@"file" success:^(id response) {
//        NSLog(@"%@", response);
//    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
//        [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"%zd", error.code]];
//    }];
    
    
    
    // 3867
    [CHMHttpTool setGroupPortraitWithGroupId:@"3867" groupPortrait:_addImg.image success:^(id response) {
        NSLog(@"---------%@", response);
    } failure:^(NSError *error) {
        NSLog(@"---------%@", error);
    }];
    
    
}


/**
 处理群组成员ID
 */
- (NSArray *)dealWithGroupMemberId {
    // 群组成员ID
    NSMutableArray *groupMemberArray = [NSMutableArray array];
    for (int i = 0; i < self.selectedMembersArray.count; i++) {
        CHMFriendModel *friendModel = self.selectedMembersArray[i];
        [groupMemberArray addObject:friendModel.UserName];
    }
    return [NSArray arrayWithArray:groupMemberArray];
}



#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
}


/**
 设置外观
 */
- (void)setupAppearance {
    self.title = @"创建群组";
    
    _nameTextField.textColor = [UIColor whiteColor];
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入群组名称" attributes:@{NSForegroundColorAttributeName: [UIColor chm_colorWithHexString:@"#999999" alpha:1.0]}];
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    _nameTextField.textColor = [UIColor chm_colorWithHexString:@"#666666" alpha:1.0];
}


#pragma mark - touch 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
