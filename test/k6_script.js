import http from "k6/http";
import { sleep } from "k6";

export default function() {
  http.get("http://api:8423/search/key/100/%25");
  sleep(1);
};