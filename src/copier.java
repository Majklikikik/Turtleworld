import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class copier {
    public static void main(String[] args) {
        File folder= new File("TurtlePrograms");
        String pathname="C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\d7cfea84-6c8f-4aa7-9e8d-1fa5fe8b3033\\saves\\Turtleworld\\computercraft\\computer\\19";
        File tf=new File(pathname);
        if (!tf.exists()){
            tf.mkdirs();
        }
        for (File f:folder.listFiles()){
            try {
                if (f.isDirectory()){
                    for (File g:f.listFiles()){
                        Files.copy(g.toPath(), Path.of(pathname+"\\"+g.getName()), StandardCopyOption.REPLACE_EXISTING);
                    }
                }
                else{
                Files.copy(f.toPath(), Path.of(pathname+"\\"+f.getName()), StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
