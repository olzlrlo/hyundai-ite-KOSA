import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonBar;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class EventProcessing extends Application {

    Label label;
    TextField field;
    ButtonBar buttonBar;
    Button button1, button2, button3;

    public static void main(String[] args) {
        Application.launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        BorderPane pane = new BorderPane();

        label = new Label("JavaFX awesome!");
        field = new TextField();
        button1 = new Button("버튼 1");
        button2 = new Button("버튼 2");
        button3 = new Button("버튼 3");
        buttonBar = new ButtonBar();
        buttonBar.getButtons().addAll(button1, button2, button3);

        pane.setTop(label);
        pane.setCenter(field);
        pane.setBottom(buttonBar);

        /* Event 처리 */

        button1.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                String msg = "버튼 1: " + field.getText();
                label.setText(msg);
            }
        });

        button2.setOnAction(e -> label.setText("버튼 2: " + field.getText()));
        button3.setOnAction(e -> label.setText("버튼 3: " + field.getText()));

        Scene scene = new Scene(pane, 500, 500);
        primaryStage.setScene(scene);
        primaryStage.show();
    }

}