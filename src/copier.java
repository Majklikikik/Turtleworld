import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.stream.IntStream;

public class copier {
    public static void main(String[] args) {
        File folder= new File("TurtlePrograms");
        String pathname="C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\5899d8fc-0033-442b-8f38-a507149f6083\\saves\\Turtleworld\\computercraft\\computer\\19";
        File tf=new File(pathname);
        if (!tf.exists()){
            tf.mkdirs();
        }


        tf=new File("C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\5899d8fc-0033-442b-8f38-a507149f6083\\saves\\Turtleworld\\computercraft\\computer\\19");
        File inAll;
        File inTest;
        if (tf.exists()){
            for (File f:tf.listFiles()){
                String [] nameparts=f.getName().split("[.]");
                String endung=nameparts[nameparts.length-1];
                System.out.println("Removing "+f.getPath());
                f.delete();
            }
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