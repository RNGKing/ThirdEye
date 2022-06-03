(import [flask [Flask request send_from_directory]])
(import json)
(setv app (Flask "__main__"))

(defn bezier-iter [t p1 p2 p3]
    (setv sub-t (- 1 t))
    (setv first (* sub-t (+ (* sub-t p1) (* t p2))))
    (setv second (* t (+ (* sub-t p2) (* t p3))))
    (+ first second))

(with-decorator (app.route "/generate_curve" :methods["POST"])
    (defn gen_curve []
        (setv json_data request.json)

        (setv x_one (float (get json_data "point_1" "x")))
        (setv x_two (float (get json_data "point_2" "x")))
        (setv x_three (float (get json_data "point_3" "x")))
        (setv x_vals (lfor t (lfor x (range 100) (/ x 100)) 
            (bezier-iter t x_one x_two x_three)))
    
        (setv y_one (float (get json_data "point_1" "y")))
        (setv y_two (float (get json_data "point_2" "y")))
        (setv y_three (float (get json_data "point_3" "y")))
        (setv y_vals (lfor t (lfor x (range 100) (/ x 100)) 
            (bezier-iter t y_one y_two y_three)))

        (setv zipped (list (zip x_vals y_vals)))
        (setv data (dfor val (range (len zipped)) [val (get zipped val)]))
        (json.dumps data)))

(with-decorator (app.route "/serve")
    (defn serve_example []
        (send_from_directory "static" "index.html")))

(with-decorator (app.route "/")
    (defn index []
        "Hello, world!"))

(app.run)