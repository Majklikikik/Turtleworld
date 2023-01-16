import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class copier {
    public static void main(String[] args) {
        // String pathname = "C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\5899d8fc-0033-442b-8f38-a507149f6083\\saves\\Turtleworld\\computercraft\\computer\\19";
        String pathname = "I:\\Games\\Minecraft\\Instances\\167b0fe2-0022-4b7b-ad26-ef6e16e05a8e\\saves\\Turtles\\computercraft\\computer\\0";
        String[] filesToKeep = { "startup", "bossState.michi", "pos.txt" };
        removeOldFiles(pathname, filesToKeep);
        copyNewFiles(pathname, filesToKeep);
    }

    public static void removeOldFiles(String pathname, String[] filesToKeep) {
        File tf = new File(pathname);
        if (tf.exists()) {
            for (File f : tf.listFiles()) {
                boolean skip = false;
                for (String string : filesToKeep) {
                    if (f.getName().equalsIgnoreCase(string)){
                        skip = true;
                    }
                }
                if (skip)
                    continue;
                // String[] nameparts = f.getName().split("[.]");
                // String endung = nameparts[nameparts.length - 1];
                System.out.println("Removing " + f.getPath());
                f.delete();
            }
        }

    }

    public static void copyNewFiles(String pathname, String[] filesToKeep) {
        File tf = new File(pathname);
        if (!tf.exists()) {
            tf.mkdirs();
        }

        File folder = new File("TurtlePrograms");
        for (File f : folder.listFiles()) {
            boolean skip = false;
                for (String string : filesToKeep) {
                    if (f.getName().equalsIgnoreCase(string)){
                        skip = true;
                    }
                }
                if (skip)
                    continue;
            try {
                if (f.isDirectory()) {
                    for (File g : f.listFiles()) {
                        Files.copy(g.toPath(), Path.of(pathname + "\\" + g.getName()),
                                StandardCopyOption.REPLACE_EXISTING);
                    }
                } else {
                    Files.copy(f.toPath(), Path.of(pathname + "\\" + f.getName()), StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}