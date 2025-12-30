# Patch Applied to mihomo-Meta

This document lists all the modifications applied from `123.patch` to the new `mihomo-Meta` core.

## Files Modified

### 1. adapter/adapter.go
- Added `UrlTestHook` callback in `URLTest` function to notify when URL test completes

### 2. adapter/patch.go (NEW)
- Created hook type `UrlTestCheck` for URL test callbacks
- Exported `UrlTestHook` variable

### 3. adapter/provider/patch.go (NEW)
- Added `GetSubscriptionInfo()` method to expose subscription information

### 4. constant/adapters.go
- Changed `DefaultTestURL` from const to var to allow runtime modification

### 5. constant/path.go
- Changed `IsSafePath` to use `features.Android` instead of `features.CMFA`
- Added case-insensitive file name matching for GeoIP, GeoSite, and MMDB files
- Added support for uppercase variants (GEOIP.dat, GEOSITE.dat, GEOIP.metadb)

### 6. constant/features/android.go (NEW)
- Created Android feature flag (replaces CMFA)

### 7. constant/features/android_stub.go (NEW)
- Created Android feature flag stub for non-Android builds

### 8. component/loopback/detector.go
- Changed to use `features.Android` instead of `features.CMFA`

### 9. component/process/process.go
- Updated comments to reference CFMA instead of CMFA (typo fix)

### 10. component/resource/fetcher.go
- Changed error log level from `Errorln` to `Warnln` for provider pull errors

### 11. component/updater/patch.go (NEW)
- Added `UpdateMMDBWithPath()` function
- Added `UpdateASNWithPath()` function
- Added `UpdateGeoIpWithPath()` function
- Added `UpdateGeoSiteWithPath()` function
- These functions allow updating geo databases to custom paths

### 12. hub/executor/executor.go
- Commented out `updateListeners()` and `updateTun()` calls in `ApplyConfig()`
- Modified `loadProvider()` to:
  - Change error log level from `Errorln` to `Warnln`
  - Add `DefaultProviderLoadedHook` callback when provider loads successfully
  - Removed `wg.Wait()` to allow non-blocking provider loading

### 13. hub/executor/patch.go (NEW)
- Created `ProviderLoadedHook` type
- Exported `DefaultProviderLoadedHook` variable

### 14. hub/route/server.go
- Removed error logging for `server.Serve()` in `start()` function
- Changed to silently ignore serve errors

### 15. listener/listener.go
- Modified `ReCreateTun()` to check if `tunLister != nil` before calling `OnReload()`

### 16. listener/patch.go (NEW)
- Added `StopListener()` function to close all listeners

### 17. listener/http/patch_android.go (NEW)
- Added `Listener()` method for Android builds to expose internal listener

### 18. tunnel/statistic/tracker.go
- Added `Meta` field to `TrackerInfo` struct for additional metadata
- Modified `NewTCPTracker()` to call `DefaultTrackerMetaHook` if set
- Modified `NewUDPTracker()` to call `DefaultTrackerMetaHook` if set

### 19. tunnel/statistic/patch.go (NEW)
- Created `TrackerMetaInfo` struct for tracker metadata
- Created `TrackerMetaHook` type
- Exported `DefaultTrackerMetaHook` variable

## Key Changes Summary

1. **Android Support**: Replaced CMFA feature flag with Android flag
2. **Hooks System**: Added multiple hooks for URL testing, provider loading, and tracker metadata
3. **Flexible Configuration**: Made DefaultTestURL variable instead of constant
4. **Database Updates**: Added functions to update geo databases to custom paths
5. **Error Handling**: Downgraded some error logs to warnings
6. **Listener Management**: Added StopListener function and Android-specific listener access
7. **File Name Handling**: Added case-insensitive file name matching for geo databases
8. **Non-blocking Loading**: Removed wait for provider loading to complete

## Notes

- All modifications maintain backward compatibility
- The patch focuses on making the core more flexible for Flutter integration
- Android-specific code is properly isolated with build tags
- Hook system allows external code to monitor core operations
