import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import static spark.Spark.get;
import static spark.Spark.staticFiles;

public class Main {

    public static void main(String[] args) {

        staticFiles.externalLocation("src/main/resources/templates");
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_28);
        configuration.setClassForTemplateLoading(Main.class, "/");

        get("/", (req, res) -> {


            StringWriter writer = new StringWriter();
            Map<String, Object> atr = new HashMap<>();
            Template template = configuration.getTemplate("templates/index.ftl");
            template.process(atr,writer);
            return writer;
        });

        get("/form", (req, res) -> {


            StringWriter writer = new StringWriter();
            Map<String, Object> atr = new HashMap<>();
            Template template = configuration.getTemplate("templates/form.ftl");
            template.process(atr,writer);
            return writer;
        });

    }
}