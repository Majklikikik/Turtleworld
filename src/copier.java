import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class copier {
    public static void main(String[] args) {
        File folder= new File("TurtlePrograms");
        String pathname="C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\46f12002-b91d-44ca-9412-20aaf8bac38e\\saves\\Turtleworld\\computercraft\\computer\\0";
        File tf=new File(pathname);
        if (!tf.exists()){
            tf.mkdirs();
        }
        for (File f:folder.listFiles()){
            try {
                Files.copy(f.toPath(), Path.of(pathname+"\\"+f.getName()), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
