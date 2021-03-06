package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import haxe.ui.backend.heaps.util.FontDetect;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.res.Image;

class AssetsBase {
    public function new() {

    }

    public function embedFontSupported():Bool {
        return #if (lime || flash || js) true #else false #end;
    }

    private function getTextDelegate(resourceId:String):String {
        return null;
    }

    private function getImageInternal(resourceId:String, callback:ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        imageFromBytes(bytes, callback);
    }

    private function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        imageFromBytes(bytes, function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void) {
        if (bytes == null) {
            callback(null);
            return;
        }

        var entry:BytesFileEntry = new BytesFileEntry("", bytes);
        var image:Image = new Image(entry);

        var size:Dynamic = image.getSize();
        var imageInfo:ImageInfo = {
            width: size.width,
            height: size.height,
            data: image.toBitmap()
        };
        callback(imageInfo);
    }

    private function getFontInternal(resourceId:String, callback:FontInfo->Void) {
        FontDetect.onFontLoaded(resourceId, function(f) {
            var fontInfo = {
                data: f
            }
            callback(fontInfo);
        }, function(f) {
            callback(null);
        });
    }

    private function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        callback(resourceId, null);
    }
}