#if PATROL_ENABLED

  import Foundation
  import GRPC

  typealias Empty = Patrol_Empty
  typealias DefaultResponse = Patrol_Empty

  final class AutomatorServer: Patrol_NativeAutomatorAsyncProvider {
    private let automator: Automator

    private let onAppReady: (Bool) -> Void

    init(automator: Automator, onAppReady: @escaping (Bool) -> Void) {
      self.automator = automator
      self.onAppReady = onAppReady
    }

    func initialize(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> Empty {
      return DefaultResponse()
    }

    func configure(
      request: Patrol_ConfigureRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> Empty {
      automator.configure(timeout: TimeInterval(request.findTimeoutMillis / 1000))
      return DefaultResponse()
    }

    // MARK: General

    func pressHome(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.pressHome()
        return DefaultResponse()
      }
    }

    func pressBack(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        throw PatrolError.methodNotImplemented("pressBack")
      }
    }
    func pressRecentApps(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.openAppSwitcher()
        return DefaultResponse()
      }
    }

    func doublePressRecentApps(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        throw PatrolError.methodNotImplemented("doublePressRecentApps")
      }
    }

    func openApp(
      request: Patrol_OpenAppRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.openApp(request.appID)
        return DefaultResponse()
      }
    }

    func openQuickSettings(
      request: Patrol_OpenQuickSettingsRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.openControlCenter()
        return DefaultResponse()
      }
    }

    // MARK: General UI interaction

    func getNativeViews(
      request: Patrol_GetNativeViewsRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> Patrol_GetNativeViewsResponse {
      return try await runCatching {
        let nativeViews = try await automator.getNativeViews(
          byText: request.selector.text,
          inApp: request.appID
        )

        return Patrol_GetNativeViewsResponse.with {
          $0.nativeViews = nativeViews
        }
      }
    }

    func tap(
      request: Patrol_TapRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.tap(
          onText: request.selector.text,
          inApp: request.appID,
          atIndex: Int(request.selector.instance)
        )
        return DefaultResponse()
      }
    }

    func doubleTap(
      request: Patrol_TapRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.doubleTap(
          onText: request.selector.text,
          inApp: request.appID
        )
        return DefaultResponse()
      }
    }

    func enterText(
      request: Patrol_EnterTextRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        switch request.findBy {
        case .index(let index):
          try await automator.enterText(
            request.data,
            byIndex: Int(index),
            inApp: request.appID,
            dismissKeyboard: request.keyboardBehavior == .showAndDismiss
          )
        case .selector(let selector):
          try await automator.enterText(
            request.data,
            byText: selector.text,
            atIndex: Int(selector.instance),
            inApp: request.appID,
            dismissKeyboard: request.keyboardBehavior == .showAndDismiss
          )
        default:
          throw PatrolError.internal("enterText(): neither index nor selector are set")
        }

        return DefaultResponse()
      }
    }

    func swipe(
      request: Patrol_SwipeRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        throw PatrolError.methodNotImplemented("swipe")
      }
    }

    func waitUntilVisible(
      request: Patrol_WaitUntilVisibleRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.waitUntilVisible(
          onText: request.selector.text,
          inApp: request.appID
        )
        return DefaultResponse()
      }
    }

    // MARK: Services

    func enableAirplaneMode(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.enableAirplaneMode()
        return DefaultResponse()
      }
    }

    func disableAirplaneMode(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.disableAirplaneMode()
        return DefaultResponse()
      }
    }

    func enableWiFi(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.enableWiFi()
        return DefaultResponse()
      }
    }

    func disableWiFi(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.disableWiFi()
        return DefaultResponse()
      }
    }

    func enableCellular(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.enableCellular()
        return DefaultResponse()
      }
    }

    func disableCellular(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.disableCellular()
        return DefaultResponse()
      }
    }

    func enableBluetooth(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.enableBluetooth()
        return DefaultResponse()
      }
    }

    func disableBluetooth(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.disableBluetooth()
        return DefaultResponse()
      }
    }

    func enableDarkMode(
      request: Patrol_DarkModeRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.enableDarkMode(request.appID)
        return DefaultResponse()
      }
    }

    func disableDarkMode(
      request: Patrol_DarkModeRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.disableDarkMode(request.appID)
        return DefaultResponse()
      }
    }

    // MARK: Notifications

    func openNotifications(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.openNotifications()
        return DefaultResponse()
      }
    }

    func closeNotifications(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.closeNotifications()
        return DefaultResponse()
      }
    }

    func closeHeadsUpNotification(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.closeHeadsUpNotification()
        return DefaultResponse()
      }
    }

    func getNotifications(
      request: Patrol_GetNotificationsRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> Patrol_GetNotificationsResponse {
      return try await runCatching {
        let notifications = try await automator.getNotifications()
        return Patrol_GetNotificationsResponse.with {
          $0.notifications = notifications
        }
      }
    }

    func tapOnNotification(
      request: Patrol_TapOnNotificationRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        switch request.findBy {
        case .index(let index):
          try await automator.tapOnNotification(
            byIndex: Int(index)
          )
        case .selector(let selector):
          try await automator.tapOnNotification(
            bySubstring: selector.textContains
          )
        default:
          throw PatrolError.internal("tapOnNotification(): neither index nor selector are set")
        }

        return DefaultResponse()
      }
    }

    // MARK: Permissions

    func isPermissionDialogVisible(
      request: Patrol_PermissionDialogVisibleRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> Patrol_PermissionDialogVisibleResponse {
      return try await runCatching {
        let visible = await automator.isPermissionDialogVisible(
          timeout: TimeInterval(request.timeoutMillis / 1000)
        )

        return Patrol_PermissionDialogVisibleResponse.with {
          $0.visible = visible
        }
      }
    }

    func handlePermissionDialog(
      request: Patrol_HandlePermissionRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        switch request.code {
        case .whileUsing:
          try await automator.allowPermissionWhileUsingApp()
        case .onlyThisTime:
          try await automator.allowPermissionOnce()
        case .denied:
          try await automator.denyPermission()
        case .UNRECOGNIZED:
          throw PatrolError.internal("handlePermissionDialog(): bad permission code")
        }

        return DefaultResponse()
      }
    }

    func setLocationAccuracy(
      request: Patrol_SetLocationAccuracyRequest,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        switch request.locationAccuracy {
        case .coarse:
          try await automator.selectCoarseLocation()
        case .fine:
          try await automator.selectFineLocation()
        case .UNRECOGNIZED:
          throw PatrolError.internal("unrecognized location accuracy")
        }

        return DefaultResponse()
      }
    }

    func debug(
      request: Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> DefaultResponse {
      return try await runCatching {
        try await automator.debug()
        return DefaultResponse()
      }
    }

    private func runCatching<T>(_ block: () async throws -> T) async throws -> T {
      // TODO: Use an interceptor (like on Android)
      // See: https://github.com/grpc/grpc-swift/issues/1148
      do {
        return try await block()
      } catch let err as PatrolError {
        Logger.shared.e(err.description)
        throw err
      } catch let err {
        throw PatrolError.unknown(err)
      }
    }

    func markPatrolAppServiceReady(
      request: Patrol_Empty,
      context: GRPCAsyncServerCallContext
    ) async throws -> Patrol_Empty {
      onAppReady(true)
      return Empty()
    }
  }

#endif
