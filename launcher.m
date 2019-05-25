
#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <unistd.h>


static void setupENV(NSString *appName)
{
    NSString *resDir = [NSBundle mainBundle].resourcePath;
    NSString *binDir = [resDir stringByAppendingPathComponent:@"bin"];
    NSString *libDir = [resDir stringByAppendingPathComponent:@"lib"];
    NSString *dataDir = [resDir stringByAppendingPathComponent:@"share"];
    NSString *etcDir = [resDir stringByAppendingPathComponent:@"etc"];
    
    NSFileManager *FM = [NSFileManager defaultManager];

//    setenv("XDG_CONFIG_DIRS",[resDir stringByAppendingPathComponent:@"xdg"].UTF8String,1);

    setenv("XDG_DATA_DIRS",dataDir.UTF8String,1);
    setenv("DYLD_LIBRARY_PATH",libDir.UTF8String,1);
    setenv("LD_LIBRARY_PATH",libDir.UTF8String,1);
    setenv("GTK_DATA_PREFIX",resDir.UTF8String,1);
    setenv("GTK_EXE_PREFIX",resDir.UTF8String,1);
    setenv("GTK_PATH",resDir.UTF8String,1);

    setenv("PANGO_RC_FILE",[etcDir stringByAppendingPathComponent:@"pango/pangorc"].UTF8String,1);
    setenv("PANGO_SYSCONFDIR",etcDir.UTF8String,1);
    setenv("PANGO_LIBDIR",libDir.UTF8String,1);

    setenv("GDK_PIXBUF_MODULE_FILE",[libDir stringByAppendingPathComponent:@"gdk-pixbuf-2.0/2.10.0/loaders.cache"].UTF8String,1);

    NSString *imFile = [etcDir stringByAppendingPathComponent:@"gtk-3.0/gtk.immodules"];
    setenv("GTK_IM_MODULE_FILE",imFile.UTF8String,1);
    NSString *i18nDir = [dataDir stringByAppendingPathComponent:@"locale"];
    NSString *lang=Nil;
    NSArray<NSString*>*langs = [NSLocale preferredLanguages];
    NSMutableArray<NSString*>*ll = [NSMutableArray new];
    for(int i=0;i<langs.count;i++){
        NSString *l = langs[i];
        l = [l stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        l = [l stringByReplacingOccurrencesOfString:@"Hant" withString:@"TW"];
        l = [l stringByReplacingOccurrencesOfString:@"Hans" withString:@"CN"];
        [ll addObject:[l substringToIndex:5]];
        [ll addObject:[l substringToIndex:2]];
    }
    for(int i=0;i<ll.count;i++){
        NSString *f=[i18nDir stringByAppendingFormat:@"/%@/LC_MESSAGES/%@.mo",ll[i],appName];
        if([FM isReadableFileAtPath:f] || [ll[i] isEqualTo:@"en"]){
            lang=ll[i];
            break;
        }
    }
    if(lang == Nil || lang.length == 0||[lang isEqualTo:@"en"]){
        lang=@"en_US";
    }
    if([lang isEqualTo:@"zh"]){
        lang=@"zh_CN";
    }
    setenv("LANG",lang.UTF8String,1);
    NSString *path = [NSString stringWithFormat:@"%@:%s",binDir,getenv("PATH")];
    setenv("PATH",path.UTF8String,1);
}

int main(int argc, const char * argv[]) {
    char exec_path[1024];
    @autoreleasepool {
        setupENV(@"file-roller");
        snprintf(exec_path,sizeof(exec_path),"%s",[[NSBundle mainBundle].executablePath stringByAppendingString:@"-bin"].UTF8String);
    }
    if(access(exec_path,X_OK) == 0)
        execvp(exec_path,argv);
    return -1;
}
