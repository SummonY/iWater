//
//  UpLoadPicture.m
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "UpLoadPicture.h"
#import "iToast.h"

NSString *TMP_UPLOAD_IMG_PATH=@"";
NSString *imageNameHead=@"";

@implementation UpLoadPicture {
    //图片名称
    NSString *imageName;
}

- (IBAction)showCamera:(id)sender {
    if ([waterWorkCode isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"选择水厂" message:@"尚未选择水厂,请选择水厂后重试！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.allowsEditing = YES;
        isCamera = TRUE;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上传图片" message:@"摄像头不可用, 请检查重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [self presentModalViewController:camera animated:YES];
        [camera release];
        
    }
}


//点击上传按钮
- (IBAction)uploadImage:(id)sender {
    imageName = imageNameHead;
    NSLog(@"image name = %@", imageName);
    if ([imageName isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传图片" message:@"尚未拍摄图片，请先选取水厂并拍摄后重试！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        
        [NSThread detachNewThreadSelector:@selector(uploadWaterWorks) toTarget:self withObject:nil];
        /*
         NSString *SCCode = [[NSString alloc] initWithFormat:@"%@",waterWorkCode];
         NSLog(@"SCCode = %@", SCCode);
         //设置参数
         NSMutableDictionary *sugestDic = [NSMutableDictionary dictionaryWithCapacity:1];
         [sugestDic setValue:[NSString stringWithFormat:@"%@", SCCode] forKey:@"SCCode"];
         
         NSString *result = [[NSString alloc] init];
         result = [self uploadPicture:sugestDic imagePathName:TMP_UPLOAD_IMG_PATH imageNameUp:imageName];
         NSLog(@"RUSULT = %@", result);
         if ([result isEqualToString:@"ok"]) {
         ++count;
         [imageCountLabel setText:[NSString stringWithFormat:@"%d", count]];
         [statusBar hide];
         [[iToast makeText:@"水厂照片信息上传成功！"] show];
         }
         else
         {
         UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"水厂图片信息上传失败，请点击重新上传！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alertLocation show];
         [statusBar hide];
         }
         */
    }
}

- (void)uploadWaterWorks
{
    NSString *SCCode = [[NSString alloc] initWithFormat:@"%@",waterWorkCode];
    NSLog(@"SCCode = %@", SCCode);
    //设置参数
    NSMutableDictionary *sugestDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sugestDic setValue:[NSString stringWithFormat:@"%@", SCCode] forKey:@"SCCode"];
    
    NSString *result = [[NSString alloc] init];
    result = [self uploadPicture:sugestDic imagePathName:TMP_UPLOAD_IMG_PATH imageNameUp:imageName];
    NSLog(@"RUSULT = %@", result);
    if ([result isEqualToString:@"ok"]) {
        [imageCountLabel setText:[NSString stringWithFormat:@"%d", count]];
        [[iToast makeText:@"水厂照片信息上传成功！"] show];
    }
    else
    {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"水厂图片信息上传失败，请点击重新上传！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
}


#pragma mark 上传图片
- (NSString *)uploadPicture:(NSMutableDictionary *)sugestDic imagePathName:(NSString *)imagePathName imageNameUp:(NSString *)imageNameUp
{
    //NSString *url = [[NSString alloc] initWithFormat:@"http://172.29.136.1:8888/SCUploadProject/UploadSCPic"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://219.140.162.169:8901/SCUploadProject/UploadSCPic"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    //form = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //[form setTimeOutSeconds:20.0];
    //form.delegate = self;
    NSLog(@"imagePathName = %@", imagePathName);
    
    NSString *boundary = @"---------------------------7db372eb000e2";
    NSString *mpBoundary = [[NSString alloc] initWithFormat:@"--%@", boundary];
    NSString *endMpBoundary = [[NSString alloc] initWithFormat:@"%@--", mpBoundary];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePathName];
    
    NSLog(@"%@", image);
    
    NSMutableString *body = [[NSMutableString alloc] init];
    
    NSArray *keys = [sugestDic allKeys];
    
    for (int i = 0; i < [keys count]; ++i) {
        NSString *key = [keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n", mpBoundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [body appendFormat:@"%@\r\n", [sugestDic objectForKey:key]];
    }
    
    NSData *data;
    if (UIImagePNGRepresentation(image)) {
        NSLog(@"PNG image");
        data = UIImagePNGRepresentation(image);
        
        if (image) {
            [body appendFormat:@"%@\r\n", mpBoundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", imageNameUp];
            [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
        }
    }
    else {
        NSLog(@"JPEG image");
        data = UIImageJPEGRepresentation(image, 0.5);
        if (image) {
            [body appendFormat:@"%@\r\n", mpBoundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", imageNameUp];
            [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        }
    }
    
    NSLog(@"data = %@", data);
    
    NSString *end = [[NSString alloc] initWithFormat:@"\r\n%@", endMpBoundary];
    NSMutableData *myRequestData = [NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *content = [[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@", boundary];
    /*
     [form addRequestHeader:@"Content-Type" value:content];
     [form addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
     [form ]
     [form setRequestMethod:@"POST"];
     [form startAsynchronous];
     [form setDidFailSelector:@selector(requestFail)];
     [form setDidFinishSelector:@selector(requestFinish)];
     */
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"resultData = %@", resultData);
    NSLog(@"result = %@", result);
    
    return result;
}


#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    NSLog(@"info = %@", info);
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {         //若为相机，则保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    imageName = [[NSString alloc] init];
    UIImage *newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    imageName = [NSString stringWithFormat:@"%@%@", [self generateUuidString], @".png"];
    
    imageNameHead = [[NSString alloc] initWithString:imageName];
    [self saveImage:newImage WithName:imageName];
    //[picker dismissViewControllerAnimated:YES];
    
    
    /*
     if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
     imageName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
     imageName = [self getFileName:imageName];
     }
     else
     {
     imageName = [self timeStampAsString];
     }
     
     NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
     
     [myDefault setValue:imageName forKey:@"imageName"];
     if (isCamera) {
     ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
     [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
     [library release];
     }
     [self performSelector:@selector(saveImg:) withObject:image afterDelay:0.0];
     */
    [image release];
    NSLog(@"imagefile name = %@", imageName);
    
    isCamera = false;
}

/*
 -(void)saveImg:(UIImage *) image
 {
 NSLog(@"Review Image");
 imageView.image = image;
 }
 */

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isCamera = false;
    [self dismissModalViewControllerAnimated:YES];
}

/*
 -(NSString *)getFileName:(NSString *)fileName
 {
 NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
 NSString *suffix = [temp lastObject];
 temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
 NSString *name = [temp lastObject];
 name = [name stringByAppendingFormat:@".%@", suffix];
 return name;
 }
 
 -(NSString *)timeStampAsString
 {
 NSDate *nowDate = [NSDate date];
 NSDateFormatter *df = [[NSDateFormatter alloc] init];
 [df setDateFormat:@"EEE-MMM-d"];
 NSString *locationString = [df stringFromDate:nowDate];
 return [locationString stringByAppendingFormat:@".png"];
 }
 */


//图片压缩
- (UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageNameF
{
    NSLog(@"保存图片");
    imageView.image = tempImage;
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageNameF];
    
    // and then we write it out
    TMP_UPLOAD_IMG_PATH= [[NSString alloc] initWithString:fullPathToFile];
    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    NSLog(@"===new fullPathToFile===%@",fullPathToFile);
    NSLog(@"===new fullPathToFile===%@",TMP_UPLOAD_IMG_PATH);
    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
}

//产生UUID
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    //[uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}


- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


@end
