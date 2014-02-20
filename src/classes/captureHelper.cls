public with sharing class captureHelper {

    public captureHelper(ApexPages.StandardController controller) {

    }

    @RemoteAction public static RemoteSaveResult saveFile(Id accountId, String imageData) {
        Attachment record = new Attachment(ParentId=accountId, name='Signature.png', ContentType='image/png', Body=EncodingUtil.base64Decode(imageData));
        Database.saveResult result = Database.insert(record,false);
        RemoteSaveResult newResult = new RemoteSaveResult();
        newResult.success = result.isSuccess();
        newResult.attachmentId = record.Id;
        newResult.errorMessage = result.isSuccess()?'':result.getErrors()[0].getMessage();
        return newResult;
    }
    
    public class RemoteSaveResult {
        public Boolean success;
        public Id attachmentId;
        public String errorMessage;
    }
}