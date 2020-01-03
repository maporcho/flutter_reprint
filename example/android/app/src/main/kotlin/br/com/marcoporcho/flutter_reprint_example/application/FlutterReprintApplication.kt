package br.com.marcoporcho.flutter_reprint_example.application

import com.github.ajalt.reprint.core.Reprint
import io.flutter.app.FlutterApplication

class FlutterReprintApplication: FlutterApplication() {

    override fun onCreate() {

        super.onCreate()

        Reprint.initialize(this)
    }

}