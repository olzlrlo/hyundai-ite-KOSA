import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class ShowLabel extends Application {

    public static void main(String[] args) {
        Application.launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        Label label = new Label("JavaFX awesome!");
        BorderPane pane = new BorderPane();
        pane.setCenter(label);

        Scene scene = new Scene(pane, 300, 120);
        primaryStage.setScene(scene);
        primaryStage.show();
    }

}